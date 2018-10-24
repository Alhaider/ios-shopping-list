//
//  Grocery.swift
//  Peppermint
//
//  Created by Luca Kaufmann on 07/05/2017.
//  Copyright © 2017 Luca Kaufmann. All rights reserved.
//

import RealmSwift

class GroceryItem: Object {
    
    @objc dynamic var groceryId: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic let addedByUser: String = ""
    @objc dynamic var amount: Int = 0
    @objc dynamic var completed: Bool = false
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var meal: Meal?
    @objc dynamic var collection: GroceryCollection?
    
    override static func primaryKey() -> String? {
        return "groceryId"
    }
}
