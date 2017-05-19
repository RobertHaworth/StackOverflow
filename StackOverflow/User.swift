//
//  User.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/17/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class User {
    
    var name:String? {
        get {
            return userDictionary["display_name"] as? String
        }
    }
    var userId:Int? {
        get {
            return userDictionary["user_id"] as? Int
        }
    }
    
    var profileImageURL:String? {
        get {
            return userDictionary["profile_image"] as? String
        }
    }
    
    fileprivate let userDictionary:Dictionary<String, AnyObject>
    
    init(userDict:Dictionary<String, AnyObject>) {
        userDictionary = userDict
    }
}
