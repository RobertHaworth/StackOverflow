//
//  Answer.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/16/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

struct AnswerState: OptionSet {
    let rawValue:Int
    
    
    
    static let notGuessed = AnswerState(rawValue: 1 << 0)
    static let userAnswer = AnswerState(rawValue: 1 << 1)
    static let correctAnswer = AnswerState(rawValue: 1 << 2)
    
    func descriptionText() -> String {
        switch self.rawValue {
        case AnswerState.notGuessed.rawValue: return "Tap to Guess"
        case AnswerState.userAnswer.rawValue: return "User Answer"
        case AnswerState.correctAnswer.rawValue: return "Correct Answer"
        case (AnswerState.correctAnswer.rawValue + AnswerState.userAnswer.rawValue): return "User guessed Correct"
        default: return ""
        }
    }
}

class Answer:StackDataObject {
    
    override var id:Int? {
        get {
            return dataDictionary["answer_id"] as? Int
        }
    }
    var isAccepted:Bool {
        get {
            guard let accepted = dataDictionary["is_accepted"] as? Bool else {
                return false
            }
            return accepted
        }
    }
    var score:Int? {
        get {
            return dataDictionary["score"] as? Int
        }
    }
}
