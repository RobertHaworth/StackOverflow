//
//  QuestionsTableViewController.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/17/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
    
    var questionsArray:Array<Question> = []
    
    fileprivate let QuestionCellIdentifier = "QuestionCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        ServerManager.sharedInstance.getQuestions { [weak self] questionArray in
            guard let array = questionArray else {
                print("array not returned.")
                return
            }
            
            self?.questionsArray = array
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
        return questionsArray.count
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
            guard indexPath.row < questionsArray.count else {
                print("no question found for cell")
                return
            }
            let question = questionsArray[indexPath.row]
            
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
            
            answersDetailController.question = questionsArray[row]
        }
    }
}
