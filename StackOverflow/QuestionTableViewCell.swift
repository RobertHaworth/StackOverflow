//
//  StackOverflowQuestionsTableViewCell.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/16/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit
import AlamofireImage

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var answersCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var earnedPointsLabel: UILabel!
    @IBOutlet weak var earnedPointsValueLabel: UILabel!

}
