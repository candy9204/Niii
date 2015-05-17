//
//  UIColorFromHex.swift
//  Niii
//
//  Created by LinShengyi on 5/17/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class UIColorFromHex {
    class func color(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}