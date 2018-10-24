//
//  GroceryCollectionTableViewCell.swift
//  Peppermint
//
//  Created by Luca on 24/02/2018.
//  Copyright © 2018 Luca Kaufmann. All rights reserved.
//

import UIKit

class GroceryCollectionTableViewCell: UITableViewCell {
    
    // The item that this cell renders.
    var collection: GroceryCollection?
    
    @IBOutlet weak var groceryCollectionName: UILabel!
    @IBOutlet weak var groceryCollectionAmount: UILabel!
    
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
    
    func setGroceryCollectionItem(groceryCollection: GroceryCollection) {
        collection = groceryCollection
        if collection!.completed {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: collection!.name)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            groceryCollectionName.attributedText = attributeString
        } else {
            groceryCollectionName.text = collection!.name
        }
        groceryCollectionAmount.text = String(describing: collection!.groceryItems.count)
    }
    
    
    
    
}

