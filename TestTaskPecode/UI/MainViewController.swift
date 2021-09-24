//
//  MainViewController.swift
//  TestTaskPecode
//
//  Created by Petro on 15.09.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchDataSource = SearchDataSource()
    
    var searchState: SearchState?
    var activePopoverSelectedFilterOptions: [String]?
    var activePopoverFilterType: FilterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        searchState = searchDataSource.getCurrentSearchState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCountryFilter", let filterPopoverViewController = segue.destination as? FilterPopoverViewController {
            filterPopoverViewController.popoverPresentationController?.delegate = self
            activePopoverFilterType = .country
            activePopoverSelectedFilterOptions = searchState?.selectedCountryFilterOptions
            filterPopoverViewController.filterPopoverViewControllerDelegate = self
        }
        
        if segue.identifier == "showCategoryFilter", let filterPopoverViewController = segue.destination as? FilterPopoverViewController {
            filterPopoverViewController.popoverPresentationController?.delegate = self
            activePopoverFilterType = .category
            activePopoverSelectedFilterOptions = searchState?.selectedCategoryFilterOptions
            filterPopoverViewController.filterPopoverViewControllerDelegate = self
        }
        
        if segue.identifier == "showSourceFilter", let filterPopoverViewController = segue.destination as? FilterPopoverViewController {
            filterPopoverViewController.popoverPresentationController?.delegate = self
            //filterPopoverViewController.filterType = .source
            activePopoverFilterType = .source
            activePopoverSelectedFilterOptions = searchState?.selectedSourcesFilterOptions
            filterPopoverViewController.filterPopoverViewControllerDelegate = self
        }
    }

    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        //Search
        
        tableView.reloadData()
    }
    
    @IBAction func testButtonTaped(_ sender: Any) {
//        let newsAPI = NewsAPI(apiKey: key)
//        newsAPI.getSources(category: nil, country: .us) { (result) in
//            print("!!!\(result)")
//        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        guard let activePopoverSelectedFilterOptions = activePopoverSelectedFilterOptions else {
            return
        }
        print("activePopoverSelectedFilterOptions = \(activePopoverSelectedFilterOptions)")
        
        searchDataSource.applySelectedFilterOptions(filterType: activePopoverFilterType!, selectedFilterOptions: activePopoverSelectedFilterOptions)
        searchState = searchDataSource.getCurrentSearchState()
    }
}

extension MainViewController: FilterPopoverViewControllerDelegate {
    func filterPopoverViewControllerFilterOptions(_ filterPopoverViewController: FilterPopoverViewController) -> [String] {
        switch activePopoverFilterType! {
        case .country:
            return searchState?.countryFilterOptions ?? []
        case .category:
            return searchState?.categoryFilterOptions ?? []
        case .source:
            return searchState?.sourcesFilterOptions ?? []
        }
    }
    
    func filterPopoverViewController(_ filterPopoverViewController: FilterPopoverViewController, isSelected filterOption: String) -> Bool {
        return activePopoverSelectedFilterOptions?.contains(filterOption) ?? false
    }
    
    func filterPopoverViewControllerNeedToInvertSelection(_ filterPopoverViewController: FilterPopoverViewController, for filterOption: String) {
        guard var activePopoverSelectedFilterOptions = activePopoverSelectedFilterOptions else {
            return
        }
        if let index = activePopoverSelectedFilterOptions.firstIndex(of: filterOption) {
            activePopoverSelectedFilterOptions.remove(at: index)
        } else {
            activePopoverSelectedFilterOptions.append(filterOption)
        }
        self.activePopoverSelectedFilterOptions = activePopoverSelectedFilterOptions
    }
}
