//
//  ServerManager.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/16/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit
import Alamofire

private let baseURL = "https://api.stackexchange.com"
private let apiURL = baseURL + "/2.2"
private let serverHeaders:Dictionary<String, String> = [:]

private let _sharedInstance = ServerManager()

final class ServerManager {
    
    private let StackOverflowAPIKey = "invalid"
    
    /* Custom Stackoverflow Filter mask ID
     *
     * This filter ID represents a filter that will return back the properties listed below
     *
     * - answer.accepted
     * - answer.answer_id
     * - answer.body
     * - answer.is_accepted
     * - answer.owner
     * - answer.question_id
     * - answer.score
     * - answer.title
     * - answer.up_vote_count
     * - error.description
     * - error.error_id
     * - error.error_name
     * - question.accepted_answer_id
     * - question.answer_count
     * - question.answers
     * - question.body
     * - question.is_answered
     * - question.owner
     * - question.question_id
     * - question.score
     * - question.tags
     * - question.title
     * - question.view_count
     * - shallow_user.display_name
     * - shallow_user.link
     * - shallow_user.profile_image
     * - shallow_user.user_id
     */
    private let filterID = "!)-gqw_JGd9NoFjDkbjrsrj*5Sz4-e(R2.8geoP_Q"
    
    class var sharedInstance:ServerManager {
        return _sharedInstance
    }

    func getQuestions(completion:(([Question]?) -> ())?) {
        // Add back in for filter - &filter=!)-gqw_JGd9NoFjDkbjrsrj*5Sz4-e(R2.8geoP_Q&key=\(StackOverflowAPIKey)
        Alamofire.request(apiURL + "/search/advanced?order=desc&sort=activity&answers=1&site=stackoverflow", method: .get, parameters: nil, encoding: JSONEncoding(options:.prettyPrinted), headers: serverHeaders).responseJSON { dataResponse in
            switch dataResponse.result {
                case .failure(let error):
                    print("error found: \(error)")
                case .success(let dataValue as Dictionary<String, AnyObject>):
                    print(dataValue)
                    guard let itemsArray = dataValue["items"] as? Array<Dictionary<String, AnyObject>> else {
                        print("unable to find items array")
                        completion?(nil)
                        return
                    }
                
                    let questionArray = itemsArray.map({ return Question(questionDict:$0)})
                    completion?(questionArray)
                default:
                    print("Success with non-dictionary root")
                    completion?(nil)
            }
        }
    }
    
    func getAnswers(question:Question) {
        Alamofire.request(apiURL + "", method:.get, parameters: nil, encoding: JSONEncoding(options: .prettyPrinted), headers:serverHeaders).responseJSON { dataResponse in
            switch dataResponse.result {
            case .failure(let error):
                print("error found: \(error)")
            case .success(let dataValue):
                print(dataValue)
            }
        }
    }
    
    func requestFilterId() {
        let dictionary:Dictionary<String, String> = [:]
        Alamofire.request(apiURL + "/filter/create", method:.post, parameters: dictionary, encoding:JSONEncoding(options: .prettyPrinted), headers:serverHeaders).validate().responseJSON { dataResponse in
        }
    }
    
    func appendFilter() {
        
    }
}
