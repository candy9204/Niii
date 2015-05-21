//
//  FriendProfile.swift
//  Niii
//
//  Created by LinShengyi on 5/21/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

struct FriendProfile {
    var userName : String
    var nickName : String
    var rating : Int
    var email : String
    var numberOfFollowers : Int
    var numberOfFollowing : Int
    var gender : Int
    var updated: Bool
    var image : UIImage
    init(userName:String = "", nickName:String = "", rating:Int = 0, email:String = "", numberOfFollowers:Int = 0, numberOfFollowing:Int = 0, gender:Int = 0, image:UIImage = UIImage(), updated:Bool = false){
        self.userName = userName
        self.nickName = nickName
        self.rating = rating
        self.email = email
        self.numberOfFollowers = numberOfFollowers
        self.numberOfFollowing = numberOfFollowing
        self.gender = gender
        self.image = image
        self.updated = updated
    }
}