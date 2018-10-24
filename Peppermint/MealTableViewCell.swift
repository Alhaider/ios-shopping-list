//
//  MealTableViewCell.swift
//  Peppermint
//
//  Created by user on 24/11/16.
//  Copyright © 2016 Luca Kaufmann. All rights reserved.
//

import UIKit
import Toucan

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    
    // The item that this cell renders.
    var mealItem: Meal?
    
    
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
    
    func setMealItem(meal: Meal) {
        mealItem = meal
        //mealImage.image = Toucan(image: UIImage(named: "one-fatty-meal.jpg")!).resize(self.frame.size, fitMode: Toucan.Resize.FitMode.crop).image
        mealName.text = mealItem?.name;
    }
    
    
   
    
}
