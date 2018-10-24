//
//  GroceryViewController.swift
//  Peppermint
//
//  Created by Luca Kaufmann on 07/05/2017.
//  Copyright © 2017 Luca Kaufmann. All rights reserved.
//

import UIKit
import RealmSwift

class GroceryViewController: UIViewController {
   
    @IBOutlet weak var groceryTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    let realm: Realm
    var grocery:GroceryItem?
    
    required init?(coder aDecoder: NSCoder) {
        let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
        self.realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[Meal.self, GroceryItem.self, GroceryCollection.self]))
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.grocery != nil {
            groceryTextField.text = self.grocery!.name
            amountTextField.text = String(self.grocery!.amount)
        }
        
        groceryTextField.becomeFirstResponder()
    }
    
    @IBAction func groceryOkButton(_ sender: Any) {
        
        let newGroceryName = self.groceryTextField.text!
        let groceryAmount = self.amountTextField.text!
       
        if grocery == nil {
            grocery = GroceryItem()
            grocery?.amount = Int(groceryAmount) ?? 1
            grocery?.name = newGroceryName
            grocery?.completed = false
        } else {
            
            grocery!.name = newGroceryName
            grocery!.amount = Int(groceryAmount) ?? 1
            grocery!.completed = false
        }
        
        let collectionKey = grocery!.name.lowercased().trimmingCharacters(in: .whitespaces)
        let groceryCollections = self.realm.objects(GroceryCollection.self).filter("collectionKey = %@", collectionKey)
        
        var groceryCollection: GroceryCollection
        
        if groceryCollections.count > 0 {
            groceryCollection = groceryCollections.first!
        } else {
            groceryCollection = GroceryCollection()
            groceryCollection.name = grocery!.name
            groceryCollection.collectionKey = collectionKey
        }
        
        grocery!.collection = groceryCollection
        
        try! self.realm.write {
            self.realm.add(grocery!, update: true)
            groceryCollection.groceryItems.append(grocery!)
            self.realm.add(groceryCollection, update: true)
        }
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        groceryTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
