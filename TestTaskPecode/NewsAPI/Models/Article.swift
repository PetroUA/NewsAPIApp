//
//  Article.swift
//  TestTaskPecode
//
//  Created by Petro on 16.09.2021.
//

import Foundation

struct Article: Codable {
    struct Source: Codable {
        let id: String?
        let name: String
    }
    
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date?
    let content: String?
}
