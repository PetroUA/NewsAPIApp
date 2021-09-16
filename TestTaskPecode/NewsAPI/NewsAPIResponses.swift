//
//  NewsAPIResponses.swift
//  TestTaskPecode
//
//  Created by Petro on 16.09.2021.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct SourcesResponse: Decodable {
    let status: String
    let sources: [Source]
}
