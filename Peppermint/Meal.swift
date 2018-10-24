//
//  Meal.swift
//  Peppermint
//
//  Created by Luca Kaufmann on 13/02/2017.
//  Copyright © 2017 Luca Kaufmann. All rights reserved.
//

import RealmSwift

class Meal: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var image: Data? = nil
    // id which is set from firebase to uniquely identify it
    @objc dynamic var mealId: String = UUID().uuidString
    @objc dynamic var addedByUser: String = ""
    @objc dynamic var completed: Bool = false
    @objc dynamic var timestamp: Date = Date()
    let groceries = List<GroceryItem>()
    
    override static func primaryKey() -> String? {
        return "mealId"
    }
    
    func addGrocery(grocery: GroceryItem) {
        self.groceries.append(grocery)
    }
    
    func removeGrocery(grocery: GroceryItem) {
        if let index = self.groceries.index(of:grocery) {
            self.groceries.remove(at: index)
        }
    }
    
//    func removeGroceryBy(key: String) {
//        self.groceries.removeValue(forKey: key)
//    }
    
    
}
