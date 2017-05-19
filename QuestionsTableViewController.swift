//
//  QuestionsTableViewController.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/17/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
    
    
    fileprivate let QuestionCellIdentifier = "QuestionCell"
    
    private var guessedOnly = false

    override func viewDidLoad() {
        super.viewDidLoad()

        ServerManager.sharedInstance.getQuestions { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionManager.sharedInstance.questions(guessedOnly: guessedOnly).count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCellIdentifier, for: indexPath)

        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellCast = cell as? QuestionTableViewCell {
            let questionArray = QuestionManager.sharedInstance.questions(guessedOnly: guessedOnly)
            guard indexPath.row < questionArray.count else {
                print("no question found for cell")
                return
            }
            let question = questionArray[indexPath.row]
            
            print(question.body!)
            cellCast.questionLabel.text = question.title
            cellCast.authorLabel.text = question.owner?.name
            cellCast.viewsCountLabel.text = "\(question.viewCount)"
            cellCast.answersCountLabel.text = "\(question.answerCount)"
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnswersSegue" {
            guard let answersDetailController = segue.destination as? QuestionDetailTableViewController else {
                return
            }
            
            guard let cell = sender as? UITableViewCell else {
                print("AnswersSegue triggered from non cell object")
                return
            }
            
            guard let row = tableView.indexPath(for: cell)?.row else {
                print("row not found")
                return
            }
            
            answersDetailController.question = QuestionManager.sharedInstance.questions(guessedOnly: guessedOnly)[row]
        }
    }
    
    @IBAction func didPressGuessed(_ sender: UIButton) {
        UIView.transition(with: tableView, duration: 2.0, options: .transitionFlipFromLeft, animations: { [weak self] in
            self?.tableView.reloadData()
        }) { complete in
        }
    }
}
