//
//  MealTableViewCell.swift
//  Peppermint
//
//  Created by user on 24/11/16.
//  Copyright © 2016 Luca Kaufmann. All rights reserved.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {
    
    // The item that this cell renders.
    var groceryItem: GroceryItem?
    
    @IBOutlet weak var groceryName: UILabel!
    @IBOutlet weak var groceryAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       

        // add a pan recognizer
        //let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        //recognizer.delegate = self
        //addGestureRecognizer(recognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setGroceryItem(grocery: GroceryItem) {
        groceryItem = grocery
        if groceryItem!.completed {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: groceryItem!.name)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            groceryName.attributedText = attributeString
        } else {
            groceryName.text = groceryItem!.name
        }
        groceryAmount.text = String(describing: groceryItem!.amount)
    }
    
    
   
    
}
