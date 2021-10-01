//
//  SearchModel.swift
//  TestTaskPecode
//
//  Created by Petro on 24.09.2021.
//

import Foundation

struct SearchModel {
    enum State: Equatable {
        case empty
        case isLoading
        case loaded
        case error(Error)
        
        static func == (lhs: SearchModel.State, rhs: SearchModel.State) -> Bool {
            switch (lhs, rhs) {
            case (empty, empty):
                return true
            case (isLoading, isLoading):
                return true
            case (loaded, loaded):
                return true
            case (error, error):
                return true
            default:
                return false
            }
        }
    }
    var state: State
    
    let countryFilterOptions: [Country]?
    let categoryFilterOptions: [Category]?
    let sourcesFilterOptions: [Source]?
    
    let selectedCountry: Country?
    let selectedCategory: Category?
    let selectedSources: [Source]?
    
    let searchQuery: String?
    
    let loadedSearchPages: [Article]?
    let totalSearchResults: Int?
}
