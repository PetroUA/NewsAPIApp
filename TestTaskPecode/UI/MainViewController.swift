//
//  MainViewController.swift
//  TestTaskPecode
//
//  Created by Petro on 15.09.2021.
//

import UIKit

class MainViewController: UIViewController, UISearchControllerDelegate {
    
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
        
        searchController.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        
        searchDataSource.delegate = self
        tableView.dataSource = self
        
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
    
    @IBAction func testButtonTaped(_ sender: Any) {
    }
}

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
        return searchModel?.totalSearchResults ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
        let imageUrl = searchModel?.loadedSearchPages?[indexPath.row].urlToImage
        let dafaultImageUrl = URL(string: "https://icons.iconarchive.com/icons/paomedia/small-n-flat/256/news-icon.png")
        
        if let data = try? Data(contentsOf: imageUrl ?? dafaultImageUrl!) {
            cell.newsImage.image = UIImage(data: data)
        }
        
        cell.titelLabel.text = searchModel?.loadedSearchPages?[indexPath.row].title ?? ""
        cell.detailsLabel.text = searchModel?.loadedSearchPages?[indexPath.row].description ?? ""
        
        return cell
    }
    
}

extension MainViewController: SearchModelControllerDelegate {
    func searchControllerDidUpdateState(_ searchModel: SearchModel) {
        self.searchModel = searchModel

        switch searchModel.state {
        case .isLoading:
            startActivityIndicator()
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
