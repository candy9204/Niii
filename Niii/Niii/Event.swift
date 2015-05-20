//
//  Event.swift
//  Niii
//
//  Created by LinShengyi on 5/19/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

struct Event {
    var eventName:String
    var holderName:String
    var address:String
    var date:String
    var followers:[UIImage]
    var comments:[[String]]
    var rating:Int
    var description:String
    init(eventName:String = "", holderName:String = "", address:String = "", date:String = "", followers:[UIImage] = [UIImage](), comments:[[String]] = [[String]](), rating:Int = 5, description:String = ""){
        self.eventName = eventName
        self.holderName = holderName
        self.address = address
        self.date = date
        self.followers = followers
        self.comments = comments
        self.rating = rating
        self.description = description
    }
}