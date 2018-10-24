//
//  ViewController.swift
//  Peppermint
//
//  Created by Luca Kaufmann on 02/11/2016.
//  Copyright © 2016 Luca Kaufmann. All rights reserved.
//

import UIKit
import RealmSwift

class MealsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mealsTableView: UITableView!
    
    var realm: Realm            // <- Insert this
    var mealsList: Results<Meal>    // <- Insert this
    
    var notificationToken: NotificationToken?

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
        self.realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[Meal.self, GroceryItem.self, GroceryCollection.self]))
        self.mealsList = realm.objects(Meal.self).sorted(byKeyPath: "timestamp", ascending: false)
        super.init(coder: aDecoder)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mealsTableView.delegate = self;
        mealsTableView.dataSource = self;
        
        notificationToken = mealsList.observe { [weak self] (changes) in
            guard let tableView = self?.mealsTableView else { return }
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
        
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            if snapshot.hasChild("AdditionalStuff"){
//
//                print("AdditionalStuff exists")
//
//            }else{
//                print("Create AdditionalStuff")
//
//               let meal = Meal(name: "Additional Stuff",
//                            addedByUser: "test",
//                            completed: false,
//                            key: "AdditionalStuff",
//                            groceries: nil)
//
//                self.ref.child("AdditionalStuff").setValue(meal.toAnyObject())
//            }
//
//
//        })
//
//        ref.observe(.value, with: { snapshot in
//
//            var newItems: [Meal] = []
//
//            // 3
//            for item in snapshot.children {
//                // 4
//                let mealItem = Meal(snapshot: item as! DataSnapshot)
//                newItems.append(mealItem)
//            }
//
//            // 5
//            self.mealsList = newItems
//            self.mealsTableView.reloadData()
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tableview methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Meal Cell", for: indexPath) as! MealTableViewCell
//        cell.mealImage.image = UIImage(named: "one-fatty-meal.jpg")
//        cell.mealName.text = "Hamburgers and French Fries"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Meal Cell", for: indexPath) as! MealTableViewCell
        
//        cell.mealName?.text = mealsList[indexPath.row].name
//        cell.mealImage.image = UIImage(named: "one-fatty-meal.jpg")
        let meal = mealsList[indexPath.row]
        cell.setMealItem(meal: meal)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mealsList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mealVC = self.storyboard!.instantiateViewController(withIdentifier: "mealVC") as! MealViewController
        mealVC.meal = mealsList[indexPath.row]
        self.present(mealVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actionsArray = [UITableViewRowAction]()
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // remove items and meal
            self.removeItemsOfMealAtIndexpath(indexPath: indexPath)
            let meal = self.mealsList[indexPath.row]
            try! self.realm.write {
                self.realm.delete(meal)
            }
        }
    
        actionsArray.append(delete)
        
        let removeItems = UITableViewRowAction(style: .normal, title: "Remove items") { (action, indexPath) in
            // only remove items
            
            self.removeItemsOfMealAtIndexpath(indexPath: indexPath)
            self.mealsTableView.setEditing(false, animated: true)
            //self.mealsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        }
        
        removeItems.backgroundColor = UIColor.orange
        
        actionsArray.append(removeItems)
        
        return actionsArray
    }

    @IBAction func logoutUser(_ sender: Any) {
        //TODO log out
//        try! Auth.auth().signOut()
        performSegue(withIdentifier: "ShowLoginForm", sender: self)
    }
    
    func removeItemsOfMealAtIndexpath(indexPath: IndexPath) {
        let meal = mealsList[indexPath.row]
        
      
        let groceryItems = meal.groceries
        if groceryItems.count > 0 {
            for groceryItem in groceryItems {
                try! self.realm.write {
                    self.realm.delete(groceryItem)
                }
            }
        }
        
        let emptyGroceryCollections = realm.objects(GroceryCollection.self).filter("groceryItems.@count = 0")
        if emptyGroceryCollections.count > 0 {
            for collection in emptyGroceryCollections {
                try! self.realm.write {
                    self.realm.delete(collection)
                }
            }
        }
        
    }
    
}

