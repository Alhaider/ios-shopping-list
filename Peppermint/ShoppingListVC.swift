//
//  ShoppingListVC.swift
//  Peppermint
//
//  Created by Luca Kaufmann on 27/11/2016.
//  Copyright © 2016 Luca Kaufmann. All rights reserved.
//

import UIKit
import RealmSwift

class ShoppingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ShoppingListItemCellDelegate {
    
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    let generator = UISelectionFeedbackGenerator()
    
    var realm: Realm            // <- Insert this
    var groceriesList: Results<GroceryCollection>    // <- Insert this
    
    var notificationToken: NotificationToken?
    
//    var groceriesList = [Grocery]()
//    var completedGroceriesList = [Grocery]()
    
    required init?(coder aDecoder: NSCoder) {
        let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
        self.realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[Meal.self, GroceryItem.self, GroceryCollection.self]))
        self.groceriesList = realm.objects(GroceryCollection.self).sorted(byKeyPath: "collectionKey", ascending: true)
        super.init(coder: aDecoder)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        notificationToken = groceriesList.observe { [weak self] (changes) in
            guard let tableView = self?.shoppingListTableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groceriesList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Grocery Cell", for: indexPath) as! GroceryCollectionTableViewCell
        
        let groceryCollection = groceriesList[indexPath.row]
        cell.setGroceryCollectionItem(groceryCollection: groceryCollection)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grocery = groceriesList[indexPath.row]
        try! self.realm.write {
            grocery.completed = !grocery.completed
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actionsArray = [UITableViewRowAction]()
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // remove items and meal
            let collection = self.groceriesList[indexPath.row]
            try! self.realm.write {
                for groceryItem in collection.groceryItems {
                    self.realm.delete(groceryItem)
                }
                self.realm.delete(collection)
            }
        }
        
        actionsArray.append(delete)
        
        return actionsArray
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Shopping List Item Delegate
    
    func editGroceryItem(grocery: GroceryItem) {
        mediumFeedback.impactOccurred()
        let groceryVC = self.storyboard!.instantiateViewController(withIdentifier: "groceryVC") as! GroceryViewController
        groceryVC.grocery = grocery
        self.present(groceryVC, animated: true, completion: nil)
    }
    
    func completeGroceryItem(grocery: GroceryItem) {
        
        generator.selectionChanged()
        
        let groceryItem = grocery
        
        if groceryItem.completed {
            groceryItem.completed = false
        } else {
            groceryItem.completed = true
        }
        
    }
}
