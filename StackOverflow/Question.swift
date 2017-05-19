//
//  Question.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/16/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class Question:StackDataObject {

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
    
    override var id:Int? {
        get {
            return dataDictionary["question_id"] as? Int
        }
    }
    var score:Int {
        get {
            if guessedAnswerID == -1 {
                return 0
            }
            let acceptedAnswer = answers?.filter({$0.isAccepted}).first
            
            if acceptedAnswer?.id == guessedAnswerID {
                return 10
            } else {
                guard let upvotes = acceptedAnswer?.upvoteCounts, let downvotes = acceptedAnswer?.downvoteCounts else {
                    return 0
                }
                
                let finalVotes = Double(upvotes - downvotes)
                
                if finalVotes > 100 {
                    return 10
                } else if finalVotes > 0 {
                    return Int(ceil(finalVotes / 10.0))
                } else if finalVotes > -50 {
                    return Int(ceil(finalVotes / 10.0))
                } else {
                    return -5
                }
            }
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
    
    // Initialize with default values
    var guessedAnswerID:Int = -1
    var guessedCorrectly:Bool {
        get {
            return correctAnswer()?.id == guessedAnswerID
        }
    }
    
    
    var answers:[Answer]?
    
    func selectGuess(answerID:Int) {
        guessedAnswerID = answerID
    }
    
    func correctAnswer() -> Answer? {
        return answers?.filter({$0.isAccepted}).first
    }
    
}
