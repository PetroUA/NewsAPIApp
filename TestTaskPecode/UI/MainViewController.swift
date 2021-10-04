//
//  MainViewController.swift
//  TestTaskPecode
//
//  Created by Petro on 15.09.2021.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchDataSource = SearchModelController()
    lazy var activityIndicator = ActivityIndicator()
    let searchController = UISearchController(searchResultsController: nil)
    var searchModel: SearchModel?
    
    var activePopoverCurrentSources: [Source]?
    var activePopoverCurrentCountry: Country?
    var activePopoverCurrentCategory: Category?
    var activePopoverFilterType: FilterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        
        searchDataSource.delegate = self
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.dataSource = self
        tableView.delegate = self
        configureRefreshControl()
        
        searchDataSource.startNewSearch()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCountryFilter", let filterPopoverViewController = segue.destination as? FilterPopoverViewController {
            filterPopoverViewController.popoverPresentationController?.delegate = self
            activePopoverFilterType = .country
            activePopoverCurrentCountry = searchModel?.selectedCountry
            filterPopoverViewController.filterPopoverViewControllerDelegate = self
        }
        
        if segue.identifier == "showCategoryFilter", let filterPopoverViewController = segue.destination as? FilterPopoverViewController {
            filterPopoverViewController.popoverPresentationController?.delegate = self
            activePopoverFilterType = .category
            activePopoverCurrentCategory = searchModel?.selectedCategory
            filterPopoverViewController.filterPopoverViewControllerDelegate = self
        }
        
        if segue.identifier == "showSourceFilter", let filterPopoverViewController = segue.destination as? FilterPopoverViewController {
            filterPopoverViewController.popoverPresentationController?.delegate = self
            activePopoverFilterType = .source
            activePopoverCurrentSources = searchModel?.selectedSources
            filterPopoverViewController.filterPopoverViewControllerDelegate = self
        }
    }
    
    func configureRefreshControl () {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                            for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        searchDataSource.startNewSearch()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    func startActivityIndicator() {
        addChild(activityIndicator)
        activityIndicator.view.frame = view.frame
        view.addSubview(activityIndicator.view)
        activityIndicator.didMove(toParent: self)
        
    }
    
    func stopActivityIndicator() {
        activityIndicator.willMove(toParent: nil)
        activityIndicator.view.removeFromSuperview()
        activityIndicator.removeFromParent()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url: URL = searchModel?.loadedSearchPages[indexPath.row].url {
            let customViewController = CustomViewController.init()
            customViewController.cellURL = url
            self.navigationController?.pushViewController(customViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "News has mot URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
/*
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}*/

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
            return
        }
        searchDataSource.applySearchQuery(searchQuery: searchBarText)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfLoadedItems = searchModel?.loadedSearchPages.count ?? 0
        let totalItems = searchModel?.totalSearchResults ?? 0
        
        return numberOfLoadedItems < totalItems ? numberOfLoadedItems + 1 : numberOfLoadedItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let numberOfLoadedItems = searchModel?.loadedSearchPages.count ?? 0
        let totalItems = searchModel?.totalSearchResults ?? 0
        
        if numberOfLoadedItems < totalItems, numberOfLoadedItems == indexPath.row {
            searchDataSource.loadNextDataPageIfNeeded()
        }
        
        if indexPath.row < numberOfLoadedItems {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
            let imageUrl = searchModel?.loadedSearchPages[indexPath.row].urlToImage
            
            
            cell.newsItemIndex = indexPath.row
            cell.newsImage.image = nil
            cell.imageLoadingActivityIndicator.isHidden = false
            cell.imageLoadingActivityIndicator.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageUrl = imageUrl,
                   let data = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        guard cell.newsItemIndex == indexPath.row else {
                            return
                        }
                        cell.imageLoadingActivityIndicator.stopAnimating()
                        cell.imageLoadingActivityIndicator.isHidden = true
                        cell.newsImage.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        guard cell.newsItemIndex == indexPath.row else {
                            return
                        }
                        cell.imageLoadingActivityIndicator.stopAnimating()
                        cell.imageLoadingActivityIndicator.isHidden = true
                        cell.newsImage.image = UIImage(named: "newsIcon")
                    }
                }
            }
            
            cell.titelLabel.text = searchModel?.loadedSearchPages[indexPath.row].title ?? ""
            cell.detailsLabel.text = searchModel?.loadedSearchPages[indexPath.row].description ?? ""
            cell.sourceLabel.text = searchModel?.loadedSearchPages[indexPath.row].source.name ?? ""
            cell.authorLabel.text = searchModel?.loadedSearchPages[indexPath.row].author ?? ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell")!
            return cell
        }
        
    }
    
}

extension MainViewController: SearchModelControllerDelegate {
    func searchControllerDidUpdateState(_ searchModel: SearchModel) {
        self.searchModel = searchModel
        
        switch searchModel.state {
        case .isLoading:
            if searchModel.lastLoadedPage <= 1 {
                startActivityIndicator()
            }
            break
        case .error(let error):
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            stopActivityIndicator()
            break
        default:
            tableView.reloadData()
            stopActivityIndicator()
        }
    }
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        guard let activePopoverFilterType = activePopoverFilterType else {
            return
        }
        
        switch activePopoverFilterType {
        case .country:
            searchDataSource.applyCurrentCountryFilter(selectedFilterOption: activePopoverCurrentCountry)
        case .category:
            searchDataSource.applyCurrentCategoryFilter(selectedFilterOption: activePopoverCurrentCategory)
        case .source:
            searchDataSource.applyCurrentSourceFilter(selectedFilterOptions: activePopoverCurrentSources)
        }
    }
}

extension MainViewController: FilterPopoverViewControllerDelegate {
    func filterPopoverViewControllerNeedsFilterOptions(_ filterPopoverViewController: FilterPopoverViewController) -> [NameableAndIdentifiable] {
        switch activePopoverFilterType! {
        case .country:
            return searchModel?.countryFilterOptions ?? []
        case .category:
            return searchModel?.categoryFilterOptions ?? []
        case .source:
            return searchModel?.sourcesFilterOptions ?? []
        }
    }
    
    func filterPopoverViewController(_ filterPopoverViewController: FilterPopoverViewController, isSelected filterOption: NameableAndIdentifiable) -> Bool {
        switch activePopoverFilterType! {
        case .country:
            return activePopoverCurrentCountry?.id == filterOption.id
        case .category:
            return activePopoverCurrentCategory?.id == filterOption.id
        case .source:
            return activePopoverCurrentSources?.first(where: {$0.id == filterOption.id}) != nil
        }
    }
    
    func filterPopoverViewControllerNeedToInvertSelection(_ filterPopoverViewController: FilterPopoverViewController, for filterOption: NameableAndIdentifiable) {
        switch filterOption {
        case let selectedCountry as Country:
            if activePopoverCurrentCountry == selectedCountry {
                activePopoverCurrentCountry = nil
            } else {
                activePopoverCurrentCountry = selectedCountry
            }
        case let selectedCategory as Category:
            if activePopoverCurrentCategory == selectedCategory {
                activePopoverCurrentCategory = nil
            } else {
                activePopoverCurrentCategory = selectedCategory
            }
            
        case let selectedSource as Source:
            guard var currentSources = activePopoverCurrentSources else {
                activePopoverCurrentSources = [selectedSource]
                return
            }
            if let index = currentSources.firstIndex(of: selectedSource) {
                currentSources.remove(at: index)
            } else {
                currentSources.append(selectedSource)
            }
            activePopoverCurrentSources = currentSources
        default:
            return
        }
        
    }
    
}
