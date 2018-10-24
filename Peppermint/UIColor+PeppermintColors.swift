//
//  UIColor+PeppermintColors.swift
//  Peppermint
//
//  Created by user on 16/05/17.
//  Copyright © 2017 Luca Kaufmann. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    static let completedRed    =   UIColor.init(hex: "AF3939")
    static let textRed         =   UIColor.init(colorLiteralRed: 200.0/255.0, green: 50.0/255.0, blue: 30.0, alpha: 1.0)
    static let peppermintGreenLight      =   UIColor.init(hex: "1CCB87")
    static let peppermintGreen =   UIColor.init(hex: "00884A")
    
}
