//
//  Source.swift
//  TestTaskPecode
//
//  Created by Petro on 16.09.2021.
//

import Foundation

struct Source: Decodable, Equatable {
    let id: String
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String
}
