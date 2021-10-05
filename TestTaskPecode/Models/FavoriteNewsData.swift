//
//  FavoriteNewsData.swift
//  TestTaskPecode
//
//  Created by Petro on 04.10.2021.
//

import UIKit
import RealmSwift

class FavoriteNewsData {
    let realm = try! Realm()
    
    func addFavoriteNews(article: Article) {
        let favoriteNews = FavoriteNews.create(withName: article.source.id, sourceName: article.source.name, author: article.author, title: article.title, newsDescription: article.description, url: article.url?.absoluteString, urlToImage: article.urlToImage?.absoluteString, publishedAt: article.publishedAt, content: article.content)
        
        print("Write to Realm")
        try! realm.write {
            realm.add(favoriteNews)
        }
    }
    
    func readFavoriteNews() -> [FavoriteNews] {
        print("Read from Realm")
        let data = realm.objects(FavoriteNews.self)
        let range = IndexSet(0...data.count - 1)
        return data.objects(at: range)
    }
    
    func updateFavoriteNews() {
        //if let firstNews = realm.objects(FavoriteNews.self).first {
            //try! realm.write {
                //firstNews.name = "New News Name"
           // }
            
            //print(realm.objects(FavoriteNews.self).first as Any)
        //}
    }
    
    func deleteFavoriteNews(id: Int) {
        print("Delete Data")
        let tableToDelete = realm.objects(FavoriteNews.self)[id]
        try! realm.write {
            realm.delete(tableToDelete)
        }
        
    }
    
}
