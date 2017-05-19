//
//  Tag.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/18/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class Tag {
    var name:String? {
        get {
            return dataDictionary["name"] as? String
        }
    }
    var count:Int? {
        get {
            return dataDictionary["count"] as? Int
        }
    }
    
    var dataDictionary:Dictionary<String, AnyObject>
    
    init(tagDictionary:Dictionary<String, AnyObject>) {
        dataDictionary = tagDictionary
    }
}
