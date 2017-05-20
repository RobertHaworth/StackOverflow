//
//  AnswerDetailTableViewCell.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/18/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class AnswerDetailTableViewCell: UITableViewCell {
    
    var state:AnswerState = .notGuessed {
        didSet {
            configureGuessLabel()
        }
    }
    
    @IBOutlet weak var tapToGuessLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    private func configureGuessLabel() {
        if state.contains(.notGuessed) || state.contains([]) {
            tapToGuessLabel.backgroundColor = UIColor.clear
        }
        
        if state.contains(.correctAnswer) {
            tapToGuessLabel.backgroundColor = UIColor.orange
        }
        
        if state.contains(.userAnswer) && !state.contains(.correctAnswer) {
            tapToGuessLabel.backgroundColor = UIColor.red
        }
        
        if state.contains(.correctAnswer) && state.contains(.userAnswer) {
            tapToGuessLabel.backgroundColor = UIColor.green
        }
        
        tapToGuessLabel.text = state.descriptionText()
    }
}
