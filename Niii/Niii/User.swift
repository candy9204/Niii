//
//  User.swift
//  Niii
//
//  Created by Yilin Xiong on 5/19/15.
//  Copyright (c) 2015 Niii. All rights reserved.
//

import Foundation
import UIKit

struct User {
    static var UID: String! = "0"
    static var nickname: String! = ""
    static var rating: String = "0"
    static var gender: String = ""
    static var photo: UIImage?
    static var updated = false
    static var eventID: String! = "4"
    static var username: String = ""
    static var URLbase: String = "http://localhost:8000"
    
    static func reset() {
        UID = "0"
        nickname = ""
        username = ""
        rating = "0"
        gender = ""
        updated = false
        photo = nil
    }
}