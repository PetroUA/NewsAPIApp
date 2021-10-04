//
//  SearchModelController.swift
//  TestTaskPecode
//
//  Created by Petro on 24.09.2021.
//

import Foundation

enum FilterType {
    case country
    case source
    case category
}

protocol SearchModelControllerDelegate : AnyObject {
    func searchControllerDidUpdateState(_ searchModel: SearchModel)
}

class SearchModelController {
    let newsAPI = NewsAPI(apiKey: "882d2acdf4b940e4b8a038bd81a45a93") // "173f64f5a786437288f02b4801373135"
    
    private var state: SearchModel.State = .empty
    private var isSourseSearch: Bool = false
    private var isSearchQuerySearch: Bool = false
    private let pageSize: Int = 20
    private var page: Int = 0
    
    private let sortBy: SortBy = .publishedAt
    
    private let categoryFilterOptions: [Category] = Category.allCases
    private var selectedCategoryFilter: Category?
    
    private let countryFilterOptions: [Country] =  Country.allCases
    private var selectedCountryFilter: Country? = .us
    
    private var sourcesFilterOptions: [Source]?
    private var selectedSourceFilters: [Source]?
    
    private var searchQuery: String?
    private var loadedSearchPages: [Article] = []
    private var totalSearchResults: Int = 0
    
    weak var delegate: SearchModelControllerDelegate?
    
    func startNewSearch(){
        page = 1
        
        loadData(needToLoadSources: true)
    }
    
    func loadNextDataPageIfNeeded() {
        page += 1

        loadData(needToLoadSources: false)
    }
    
    func applyCurrentCategoryFilter(selectedFilterOption: Category?) {
        guard selectedCategoryFilter != selectedFilterOption else {
            return
        }
        selectedCategoryFilter = selectedFilterOption
        selectedSourceFilters = nil
        page = 1
        
        loadData(needToLoadSources: true)
    }
    
    func applyCurrentCountryFilter(selectedFilterOption: Country?) {
        guard selectedCountryFilter != selectedFilterOption else {
            return
        }
        selectedCountryFilter = selectedFilterOption
        selectedSourceFilters = nil
        page = 1
        
        loadData(needToLoadSources: true)
    }
    
    
    func applyCurrentSourceFilter(selectedFilterOptions: [Source]?) {
        guard selectedSourceFilters != selectedFilterOptions else {
            return
        }
        selectedSourceFilters = selectedFilterOptions
        page = 1
        
        loadData(needToLoadSources: false)
    }
    
    func applySearchQuery(searchQuery: String?) {
        guard self.searchQuery != searchQuery else {
            return
        }
        self.searchQuery = searchQuery
        page = 1
        
        loadData(needToLoadSources: false)
    }
    
    private func loadData(needToLoadSources: Bool) {
        state = .isLoading
        notifyAboutStateChange()
        if page == 1 {
            loadedSearchPages = []
        }
        
        let group = DispatchGroup()
        
        if needToLoadSources {
            group.enter()
            newsAPI.getSources(category: selectedCategoryFilter, country: selectedCountryFilter) { [weak self] (result) in
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    do {
                        let response = try result.get()
                        self.sourcesFilterOptions = response.sources
                        group.leave()
                    }
                    catch {
                        self.state = .error(error)
                        group.leave()
                    }
                }
            }
        }
        
        group.enter()
        var curentCountryFilter: Country?
        var curentCategoryFilter: Category?
        if !isSourseSearch {
            curentCountryFilter = selectedCountryFilter
            curentCategoryFilter = selectedCategoryFilter ?? nil
        } else {
            selectedSourceFilters = nil
        }
        
        if !isSearchQuerySearch {
            curentCountryFilter = selectedCountryFilter
            curentCategoryFilter = selectedCategoryFilter ?? nil
            selectedSourceFilters = nil
        }
        
        newsAPI.getTopHeadlines(requestParametrers: NewsAPI.NewsRequestParameters(searchKeywords: searchQuery, country: curentCountryFilter, category: curentCategoryFilter, everythingSources: selectedSourceFilters, sortBy: sortBy, page: page, pageSize: pageSize)){ [weak self] (result) in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                do {
                    let response = try result.get()
                    self.loadedSearchPages.append(contentsOf: response.articles)
                    self.totalSearchResults = response.totalResults
                    group.leave()
                }
                catch {
                    self.state = .error(error)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] () in
            guard let self = self else {
                return
            }
            
            if self.state == .isLoading {
                self.state = .loaded
            }
            self.notifyAboutStateChange()
        }
    }
    
    private func notifyAboutStateChange() {
        let currentState = SearchModel(state: state,
                                       countryFilterOptions: countryFilterOptions,
                                       categoryFilterOptions: categoryFilterOptions,
                                       sourcesFilterOptions: sourcesFilterOptions,
                                       selectedCountry: selectedCountryFilter,
                                       selectedCategory: selectedCategoryFilter,
                                       selectedSources: selectedSourceFilters,
                                       searchQuery: searchQuery,
                                       loadedSearchPages: loadedSearchPages,
                                       lastLoadedPage: page,
                                       totalSearchResults: totalSearchResults)
        
        delegate?.searchControllerDidUpdateState(currentState)
    }
}
