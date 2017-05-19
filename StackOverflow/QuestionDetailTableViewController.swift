//
//  AnswersTableViewController.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/18/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuestionDetailTableViewController: UITableViewController {
    
    var question:Question?
    fileprivate let QuestionDetailCellIdentifier = "QuestionDetailCell"
    fileprivate let AnswerDetailCellIdentifer = "AnswerDetailCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let unwrappedQuestion = question else {
            SVProgressHUD.showError(withStatus: "Unable to find question to get answers")
            return
        }
        
        ServerManager.sharedInstance.getAnswers(question: unwrappedQuestion) { [weak self] in
            self?.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1:
                guard let count = question?.answers?.count else {
                    return 0
                }
                
                return count
            default: return 0
        }
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let maxWidth = tableView.bounds.size.width
        let attributedString:NSAttributedString
        switch indexPath.section {
            case 0:
                guard let unwrappedAttributedString = question?.body else {
                    return 150.0
                }
                
                attributedString = unwrappedAttributedString
            case 1:
                guard let unwrappedAttributedString = question?.answers?[indexPath.row].body else {
                    return 150.0
                }
            
                attributedString = unwrappedAttributedString
            default:
                return 150.0
            }
        
        let calculatedRect = attributedString.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options:[ .usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return calculatedRect.height + 60.0 /* Adding 60.0f to the height required for the cell to account for the UIButton height and all vertical constraints */
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        
        switch indexPath.section {
            case 0: cell = tableView.dequeueReusableCell(withIdentifier: QuestionDetailCellIdentifier, for: indexPath)
            default: cell = tableView.dequeueReusableCell(withIdentifier: AnswerDetailCellIdentifer, for: indexPath)
        }
        
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Question"
            case 1: return "Answers"
            default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        switch indexPath.section {
            case 0:
                
                guard let questionCell = cell as? QuestionDetailTableViewCell else {
                    print("invalid type of cell")
                    return
                }
                
                questionCell.bodyTextView.attributedText = question?.body
                questionCell.questionURL = question?.link
            case 1:
                
                guard let answerCell = cell as? AnswerDetailTableViewCell else {
                    print("invalid type of cell")
                    return
                }
                
                guard let answer = question?.answers?[indexPath.row] else {
                    print("unable to find answer at row \(indexPath.row)")
                    return
                }
                answerCell.bodyTextView.attributedText = answer.body
                
                if question?.guessedAnswerID != -1 {
                    //answered
                    if (question?.guessedAnswerID == answer.answerId) && !answer.isAccepted {
                        // This is the guessed answer but not the correct one
                        answerCell.state = .userAnswer
                        
                    } else if (question?.guessedAnswerID == answer.answerId) && answer.isAccepted {
                        answerCell.state = [.userAnswer, .correctAnswer]
                    } else if answer.isAccepted {
                        answerCell.state = .correctAnswer
                    } else {
                        answerCell.state = []
                    }
                    
                } else {
                    answerCell.state = .notGuessed
                }
//                answerCell.state
            default:
                print("unknown section implemented")
                return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 && question?.guessedAnswerID == -1 else {
            return
        }
        
        
        
        guard let answerID = question?.answers?[indexPath.row].answerId else {
            return
        }
        
        question?.selectGuess(answerID: answerID)
        tableView.reloadSections(IndexSet(integer:indexPath.section), with: .automatic)
    }
}
