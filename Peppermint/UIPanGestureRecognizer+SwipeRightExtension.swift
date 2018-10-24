//
//  UIPanGestureRecognizer+SwipeRightExtension.swift
//  Peppermint
//
//  Created by Luca Kaufmann on 28/04/2017.
//  Copyright © 2017 Luca Kaufmann. All rights reserved.
//
import UIKit


extension UIPanGestureRecognizer {
    
    func isRight(theViewYouArePassing: UIView) -> Bool {
        let v : CGPoint = velocity(in: theViewYouArePassing)
        if v.x > 0 {
            print("Gesture went right")
            return true
        } else {
            print("Gesture went left")
            return false
        }
    }
}
