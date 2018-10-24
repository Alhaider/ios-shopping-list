//
//  GroceryCollection.swift
//  Peppermint
//
//  Created by Luca on 24/02/2018.
//  Copyright © 2018 Luca Kaufmann. All rights reserved.
//

import RealmSwift

class GroceryCollection: Object {
    
    @objc dynamic var groceryCollectionId: String = UUID().uuidString
    @objc dynamic var collectionKey: String = ""
    @objc dynamic var name: String = ""
//    @objc dynamic var amount: Int = 0
    @objc dynamic var completed: Bool = false
    @objc dynamic var timestamp: Date = Date()
    let groceryItems = List<GroceryItem>()
    
    override static func primaryKey() -> String? {
        return "groceryCollectionId"
    }
}
