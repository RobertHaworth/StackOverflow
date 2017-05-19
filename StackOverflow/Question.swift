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
            guard let unwrappedCount = dataDictionary["answer_count"] as? Int else {
                return 0
            }
            return unwrappedCount
        }
    }
    
    var isAnswered:Bool? {
        get {
            return dataDictionary["is_answered"] as? Bool
        }
    }
    
    var questionId:Int? {
        get {
            return dataDictionary["question_id"] as? Int
        }
    }
    var score:Int? {
        get {
            return dataDictionary["score"] as? Int
        }
    }
    var title:String? {
        get {
            return dataDictionary["title"] as? String
        }
    }
    var viewCount:Int {
        get {
            guard let unwrappedCount = dataDictionary["view_count"] as? Int else {
                return 0
            }
            return unwrappedCount
        }
    }
    var link:String? {
        get {
            return dataDictionary["link"] as? String
        }
    }
    
    var authorName:String? {
        get {
            return owner?.name
        }
    }
    
    // Initialize with default values
    var guessedAnswerID:Int = -1
    
    var body:NSAttributedString? {
        get {
            let data = (dataDictionary["body"] as? String)?.data(using: String.Encoding.unicode)
            
            do {
                let string = try NSAttributedString(data: data!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
                
                return string
            } catch let error as NSError {
                print("unable to convert body to attributed string for HTML string interpolation \n \(error)")
                return nil
            }
        }
    }
    
    var owner:User?
    var answers:[Answer]?
    
    private let dataDictionary:Dictionary<String, AnyObject>
    
    init(questionDictionary:Dictionary<String, AnyObject>) {
        dataDictionary = questionDictionary
        
        guard let ownerDictionary = dataDictionary["owner"] as? Dictionary<String, AnyObject> else {
            print("no owner found")
            return
        }
        
        owner = User(userDict: ownerDictionary)
    }
    
    func selectGuess(answerID:Int) {
        guessedAnswerID = answerID
    }
    
}
