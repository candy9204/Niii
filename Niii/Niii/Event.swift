//
//  Event.swift
//  Niii
//
//  Created by LinShengyi on 5/19/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

struct Event {
    var name:String
    var address:String
    var date:String
    var followers:[UIImage]
    var comments:[[String]]
    init(name:String = "", address:String = "", date:String = "", followers:[UIImage] = [UIImage](), comments:[[String]] = [[String]]()){
        self.name = name
        self.address = address
        self.date = date
        self.followers = followers
        self.comments = comments
    }
}