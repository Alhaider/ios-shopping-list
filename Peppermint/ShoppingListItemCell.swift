//
//  ShoppingListItemCell.swift
//  Peppermint
//
//  Created by Luca Kaufmann on 27/11/2016.
//  Copyright © 2016 Luca Kaufmann. All rights reserved.
//

import UIKit

protocol ShoppingListItemCellDelegate {
    func editGroceryItem(grocery: GroceryItem)
    func completeGroceryItem(grocery: GroceryItem)
}

class ShoppingListItemCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var shoppingListItem: UILabel!
    @IBOutlet weak var shoppingListItemAmount: UILabel!
    @IBOutlet weak var cellView: UIView!

    
    var grocery: GroceryItem! = nil
    var delegate: ShoppingListItemCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // add a tap recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(recognizer:)))
        longPressRecognizer.delegate = self
        addGestureRecognizer(longPressRecognizer)
    }
    
    func setGroceryItem(grocery: GroceryItem) {
        self.grocery = grocery
        //mealImage.image = Toucan(image: UIImage(named: "one-fatty-meal.jpg")!).resize(self.frame.size, fitMode: Toucan.Resize.FitMode.crop).image
        shoppingListItem.text = grocery.name
        shoppingListItemAmount.text = String(grocery.amount)
        
        
        if grocery.completed {
            self.cellView.backgroundColor = UIColor.completedRed
        } else {
            self.cellView.backgroundColor = UIColor.peppermintGreenLight
           
        } 
    }
    
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        delegate!.completeGroceryItem(grocery: self.grocery)
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.began){
            delegate!.editGroceryItem(grocery: self.grocery)
        }
    }
    
    
}
