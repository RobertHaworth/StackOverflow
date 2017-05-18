//
//  Question.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/16/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class Question {

    var answerCount:Int {
        get {
            guard let unwrappedCount = backingDict["answer_count"] as? Int else {
                return 0
            }
            return unwrappedCount
        }
    }
    
    var isAnswered:Bool? {
        get {
            return backingDict["is_answered"] as? Bool
        }
    }
    
    var questionId:Int? {
        get {
            return backingDict["question_id"] as? Int
        }
    }
    var score:Int? {
        get {
            return backingDict["score"] as? Int
        }
    }
    var title:String? {
        get {
            return backingDict["title"] as? String
        }
    }
    var viewCount:Int {
        get {
            guard let unwrappedCount = backingDict["view_count"] as? Int else {
                return 0
            }
            return unwrappedCount
        }
    }
    var link:String? {
        get {
            return backingDict["link"] as? String
        }
    }
    
    var authorName:String? {
        get {
            return owner?.name
        }
    }
    
    var owner:User?
    var answers:[Answer]?
    
    private let backingDict:Dictionary<String, AnyObject>
    
    init(questionDict:Dictionary<String, AnyObject>) {
        backingDict = questionDict
        
        guard let ownerDictionary = backingDict["owner"] as? Dictionary<String, AnyObject> else {
            print("no owner found")
            return
        }
        
        owner = User(userDict: ownerDictionary)
    }
    
}
