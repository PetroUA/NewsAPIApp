//
//  SearchState.swift
//  TestTaskPecode
//
//  Created by Petro on 24.09.2021.
//

import Foundation

struct SearchState {
    let countryFilterOptions: [String]
    let categoryFilterOptions: [String]
    let sourcesFilterOptions: [String]
    
    let selectedCountryFilterOptions: [String]
    let selectedCategoryFilterOptions: [String]
    let selectedSourcesFilterOptions: [String]
    
    let searchQuery: String
    
    let loadedSearchPages: [[Article]]?
    let totalSearchResults: Int?
}
