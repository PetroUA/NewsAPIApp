//
//  FavoriteNews.swift
//  TestTaskPecode
//
//  Created by Petro on 04.10.2021.
//

import UIKit
import RealmSwift

class FavoriteNews: Object {
    @objc dynamic var sourceId: String?
    @objc dynamic var sourceName: String?
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var newsDescription: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: Date?
    @objc dynamic var content: String?
    
    static func create(withName sourceId: String?, sourceName: String?, author: String?, title: String?, newsDescription: String?, url: String?, urlToImage: String?, publishedAt: Date?, content: String?) -> FavoriteNews {
        let favoriteNews = FavoriteNews()
        favoriteNews.sourceId = sourceId
        favoriteNews.sourceName = sourceName
        favoriteNews.author = author
        favoriteNews.title = title
        favoriteNews.newsDescription = newsDescription
        favoriteNews.url = url
        favoriteNews.urlToImage = urlToImage
        favoriteNews.publishedAt = publishedAt
        favoriteNews.content = content
        
        return favoriteNews
    }
}
