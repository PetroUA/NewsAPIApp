//
//  FavoriteNewsData.swift
//  TestTaskPecode
//
//  Created by Petro on 04.10.2021.
//

import UIKit
import RealmSwift

class FavoriteNewsData {
    /*
    private func write() {
        let table = Furniture.create(withName: "table")
        let chair = Furniture.create(withName: "chair")
        let store = Store.create(withName: "Test Store",
                                 furniture: [table, chair])
        
        // Write to Realm
        print("Write to Realm")
        try! realm.write {
            realm.add(table)
            realm.add(chair)
            realm.add(store)
        }
    }*/
    
}

class FavoriteNews: Object {
    @objc dynamic var name = ""
    
    static func create(withName name: String) -> FavoriteNews {
        let favoriteNews = FavoriteNews()
        favoriteNews.name = name
        
        return favoriteNews
    }
}
