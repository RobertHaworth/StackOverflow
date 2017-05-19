//
//  QuestionDetailTableViewCell.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/18/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit



class QuestionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyTextView: UITextView!
    var questionURL:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didPressQuestionPageButton(_ sender: UIButton) {
        guard let unwrappedQuestionURL = questionURL else {
            print("no questionURL found")
            return
        }
        
        guard let url = URL(string: unwrappedQuestionURL) else {
            print("unable to make URL from questionURL")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
