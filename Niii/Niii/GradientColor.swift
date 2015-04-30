//
//  GradientColor.swift
//  Niii
//
//  Created by LinShengyi on 4/15/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func blueColor() -> CAGradientLayer {
        let topColor = UIColor(red: (170/255.0), green: (230/255.0), blue: (255/255.0), alpha: 1)
        let bottomColor = UIColor(red: (25/255.0), green: (100/255.0), blue: (240/255.0), alpha: 1)
        
        let gradientColors: Array <AnyObject> = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: Array <AnyObject> = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}