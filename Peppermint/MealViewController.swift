//
//  MealViewController.swift
//  
//
//  Created by Luca Kaufmann on 13/02/2017.
//
//

import UIKit
import RealmSwift

class MealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var MealTextField: UITextField!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    typealias groceryTuple = (key: String, amount: String)
    
    let realm: Realm
    var meal:Meal?
    var notificationToken: NotificationToken?

    required init?(coder aDecoder: NSCoder) {
        let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
        self.realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[Meal.self, GroceryItem.self, GroceryCollection.self]))
        super.init(coder: aDecoder)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.meal != nil {
            MealTextField.text = self.meal?.name

            //dictionaryToArray(dictionary: (self.meal?.groceries)!)

        }
        
        ingredientsTableView.delegate = self;
        ingredientsTableView.dataSource = self;
        
        setNotification()
        
        MealTextField.becomeFirstResponder()
    }
    
    func setNotification() {
        notificationToken = meal?.groceries.observe { [weak self] (changes) in
            guard let tableView = self?.ingredientsTableView else { return }
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
    
    func saveMeal() {
        let newMealName = self.MealTextField.text!
        
        if meal == nil {
            // create meal
            meal = Meal()
            meal?.name = newMealName
            
            try! self.realm.write {
                self.realm.add(meal!)
            }
            
            setNotification()
        } else {
            
            try! self.realm.write {
                meal?.name = newMealName
            }
           // self.observeMeal()
        }

    }
    
    
    @IBAction func MealOkButton(_ sender: Any) {
        
        self.saveMeal()
        
        self.dismiss(animated: true, completion: nil)
        
//        
//        let dictionaryTodo = [ "name"    : meal!.name, "uniqueId" : key]
//        
//        let childUpdates = ["/mealsList/\(key)": dictionaryTodo]
//        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
//            self.dismiss(animated: true, completion: nil)
//        })
    }
    @IBAction func cancelMeal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        
        self.saveMeal()
        
        let alert = UIAlertController(title: "Add ingredient",
                                      message: "Add ingredient",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        // 1
                                        let ingredientField = alert.textFields![0]
                                        let amountField = alert.textFields![1]
                                        
                                        let newGrocery = GroceryItem()
                                        newGrocery.name = ingredientField.text!
                                        newGrocery.amount = Int(amountField.text!) ?? 1
                                        newGrocery.meal = self.meal
                                        let collectionKey = newGrocery.name.lowercased().trimmingCharacters(in: .whitespaces)
                                        let groceryCollections = self.realm.objects(GroceryCollection.self).filter("collectionKey = %@", collectionKey)
                                        
                                        var groceryCollection: GroceryCollection
                                        
                                        if groceryCollections.count > 0 {
                                            groceryCollection = groceryCollections.first!
                                        } else {
                                            groceryCollection = GroceryCollection()
                                            groceryCollection.name = newGrocery.name
                                            groceryCollection.collectionKey = collectionKey
                                        }
                                        
                                        newGrocery.collection = groceryCollection
                                        
                                        try! self.realm.write {
                                            self.meal?.groceries.append(newGrocery)
                                            groceryCollection.groceryItems.append(newGrocery)
                                            self.realm.add(groceryCollection, update: true)
                                        }
                                        
                                        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textIngredient in
            textIngredient.placeholder = "Enter an ingredient"
        }
        
        alert.addTextField { textAmount in
            textAmount.placeholder = "Enter the amount"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Meal Cell", for: indexPath) as! MealTableViewCell
        //        cell.mealImage.image = UIImage(named: "one-fatty-meal.jpg")
        //        cell.mealName.text = "Hamburgers and French Fries"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient Cell", for: indexPath) as! GroceryTableViewCell
        
        
        //        cell.mealName?.text = mealsList[indexPath.row].name
        //        cell.mealImage.image = UIImage(named: "one-fatty-meal.jpg")
        let grocery = meal!.groceries[indexPath.row]
//        cell.setGroceryItem(grocery: grocery)
        
        if (grocery.collection!.completed) {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: grocery.name)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.groceryName.attributedText = attributeString
        } else {
            cell.groceryName.text = grocery.name
        }

        cell.groceryAmount.text = String(grocery.amount)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = meal?.groceries.count {
            return count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actionsArray = [UITableViewRowAction]()
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // remove items and meal
            try! self.realm.write {
                self.realm.delete(self.meal!.groceries[indexPath.row])
            }
        }
        
        actionsArray.append(delete)
        
        return actionsArray
    }


    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.MealTextField.resignFirstResponder()
    }
}
