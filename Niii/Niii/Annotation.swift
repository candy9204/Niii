//
//  Annotation.swift
//  Niii
//
//  Created by Yilin Xiong on 5/20/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String!
    var subtitle: String!
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
