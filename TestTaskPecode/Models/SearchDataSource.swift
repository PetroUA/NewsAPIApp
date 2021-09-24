//
//  SearchDataSource.swift
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

class SearchDataSource {
    let newsAPI = NewsAPI(apiKey: "882d2acdf4b940e4b8a038bd81a45a93")
    
    let categoryFilterOptions: [String] = [Category.business.rawValue, Category.entertainment.rawValue, Category.general.rawValue, Category.health.rawValue, Category.science.rawValue]
    let countryFilterOptions: [String] =  [Country.ae.rawValue, Country.ar.rawValue, Country.at.rawValue, Country.au.rawValue, Country.be.rawValue, Country.bg.rawValue, Country.br.rawValue, Country.ca.rawValue, Country.ch.rawValue, Country.cn.rawValue, Country.co.rawValue, Country.cu.rawValue, Country.cz.rawValue, Country.de.rawValue, Country.eg.rawValue, Country.fr.rawValue, Country.gb.rawValue, Country.gr.rawValue, Country.hk.rawValue, Country.hu.rawValue, Country.id.rawValue, Country.ie.rawValue, Country.il.rawValue, Country.`in`.rawValue, Country.it.rawValue, Country.jp.rawValue, Country.kr.rawValue, Country.lt.rawValue, Country.lv.rawValue, Country.ma.rawValue, Country.mx.rawValue, Country.my.rawValue, Country.ng.rawValue, Country.nl.rawValue, Country.no.rawValue, Country.nz.rawValue, Country.ph.rawValue, Country.pl.rawValue, Country.pt.rawValue, Country.ro.rawValue, Country.rs.rawValue, Country.ru.rawValue, Country.sa.rawValue, Country.se.rawValue, Country.sg.rawValue, Country.si.rawValue, Country.sk.rawValue, Country.th.rawValue, Country.tr.rawValue, Country.tw.rawValue, Country.ua.rawValue, Country.us.rawValue, Country.ve.rawValue, Country.za.rawValue]
    
    var countrySelectedFilterOptions: [String]?
    var sourceSelectedFilterOptions: [String]?
    var categorySelectedFilterOptions: [String]?
    var searchQuery: String?
    
    func applySelectedFilterOptions(filterType: FilterType, selectedFilterOptions: [String]) {
        switch filterType {
        case .country:
            countrySelectedFilterOptions = selectedFilterOptions

        case .source:
            sourceSelectedFilterOptions = selectedFilterOptions

        case .category:
            categorySelectedFilterOptions = selectedFilterOptions
        }
    }
    
    //        newsAPI.getSources(category: nil, country: .us) { (result) in
    //        print("!!!\(result)")
    
    func applySearchQuery(searchQuery: String) {
        self.searchQuery = searchQuery
    }
    
    func getCurrentSearchState() -> SearchState {
        let currentSearchState = SearchState(countryFilterOptions: countryFilterOptions, categoryFilterOptions: categoryFilterOptions, sourcesFilterOptions: [], selectedCountryFilterOptions: countrySelectedFilterOptions ?? [], selectedCategoryFilterOptions: categorySelectedFilterOptions ?? [], selectedSourcesFilterOptions: sourceSelectedFilterOptions ?? [], searchQuery: searchQuery ?? "", loadedSearchPages: nil, totalSearchResults: nil)
        
        return currentSearchState
    }
    
}
