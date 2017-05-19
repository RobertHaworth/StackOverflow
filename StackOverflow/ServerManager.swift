//
//  ServerManager.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/16/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

private let baseURL = "https://api.stackexchange.com"
private let apiURL = baseURL + "/2.2"
private let serverHeaders:Dictionary<String, String> = [:]

private let _sharedInstance = ServerManager()

enum StackoverflowError:Error {
    case itemArrayMissing, dictionaryMissing, questionIDMissing
    
    var localizedDescription: String {
        get {
            switch self {
                case .itemArrayMissing:  return "Unable to find Item Array"
                case .dictionaryMissing: return "Unable to find Dictionary"
                case .questionIDMissing: return "Question ID not found when getting Answers"
            }
        }
    }
}


final class ServerManager {
    
    private let site = "stackoverflow"
    
    /* Custom Stackoverflow Filter mask ID
     *
     * This filter ID represents a filter that will return back the properties listed below
     *
     * - backoff
     * - error_id
     * - error_message
     * - error_name
     * - has_more
     * - items
     * - quota_max
     * - quota_remaining
     * - answer.answer_id
     * - answer.body
     * - answer.is_accepted
     * - answer.link
     * - answer.owner
     * - answer.question_id
     * - answer.score
     * - answer.title
     * - error.description
     * - error.error_id
     * - error.error_name
     * - filter.filter
     * - filter.filter_type
     * - filter.included_fields
     * - question.accepted_answer_id
     * - question.answer_count
     * - question.body
     * - question.is_answered
     * - question.owner
     * - question.question_id
     * - question.score
     * - question.tags
     * - question.title
     * - question.view_count
     * - shallow_user.display_name
     * - shallow_user.profile_image
     * - shallow_user.user_id
     */
    private let filterID = "!)TMXTVHp7vWlfYhU2XhwMEc-sfkcw2qOUlG7opna(qn_mlN*rBr4E3x6L"
    
    
    class var sharedInstance:ServerManager {
        return _sharedInstance
    }
    
    func getQuestions(completion:(() -> ())?) {
        // Add back in for filter - &filter=!)-gqw_JGd9NoFjDkbjrsrj*5Sz4-e(R2.8geoP_Q&key=\(StackOverflowAPIKey)
        
        Alamofire.request(apiURL + "/search/advanced?order=desc&sort=activity&accepted=True&answers=2&site=\(site)&filter=\(filterID)", method: .get, parameters: nil, encoding: JSONEncoding(options:.prettyPrinted), headers: serverHeaders).responseJSON { [weak self] dataResponse in
            switch dataResponse.result {
                case .failure(let error):
                    self?.presentError(error: error)
                case .success(let dataValue as Dictionary<String, AnyObject>):
                    guard let itemsArray = dataValue["items"] as? Array<Dictionary<String, AnyObject>> else {
                        self?.presentError(error: StackoverflowError.itemArrayMissing)
                        completion?()
                        return
                    }
                
                    let questionArray = itemsArray.map({ return Question(dictionary:$0)})
                    QuestionManager.sharedInstance.updateQuestions(newQuestions: questionArray)
                    completion?()
                default:
                    print("Success with non-dictionary root")
                    self?.presentError(error: StackoverflowError.dictionaryMissing)
                    completion?()
            }
        }
    }
    
    func getAnswers(question:Question, completion:(() -> ())?) {
        guard let questionID = question.id else {
            self.presentError(error: StackoverflowError.questionIDMissing)
            completion?()
            return
        }
        Alamofire.request(apiURL + "/questions/\(questionID)/answers?site=\(site)&filter=\(filterID)", method:.get, parameters: nil, encoding: JSONEncoding(options: .prettyPrinted), headers:serverHeaders).responseJSON { [weak self] dataResponse in
            switch dataResponse.result {
                case .failure(let error):
                    print("error found: \(error)")
                    self?.presentError(error: error)
                case .success(let dataValue as Dictionary<String, AnyObject>):
//                    print(dataValue)
                    guard let items = dataValue["items"] as? Array<Dictionary<String, AnyObject>> else {
                        print("unable to find items array")
                        self?.presentError(error: StackoverflowError.itemArrayMissing)
                        completion?()
                        return
                    }
                
                    question.answers = items.map({ return Answer(dictionary: $0)})
                    completion?()
                default:
                    print("Success with non-dictionary root")
                    self?.presentError(error: StackoverflowError.dictionaryMissing)
                    completion?()
            }
        }
    }
    
    func getTags(completion:(([Tag]?) -> ())?) {
        Alamofire.request(apiURL + "/tags?order=desc&sort=popular&site=\(site)", method: .get, parameters: nil, encoding: JSONEncoding(options:.prettyPrinted), headers: serverHeaders).responseJSON { [weak self] dataResponse in
            switch dataResponse.result {
                case .failure(let error):
                    self?.presentError(error: error)
                    completion?(nil)
                    return
                case .success(let dataValue as Dictionary<String, AnyObject>):
                    print(dataValue)
                
                    guard let items = dataValue["items"] as? Array<Dictionary<String, AnyObject>> else {
                        print("unable to find items array")
                        self?.presentError(error: StackoverflowError.itemArrayMissing)
                        completion?(nil)
                        return
                    }
                
                    let tagArray = items.map({return Tag(tagDictionary: $0)})
                    completion?(tagArray)
                    return
                default:
                    print("Success within non-dictionary root")
                    self?.presentError(error: StackoverflowError.dictionaryMissing)
                    completion?(nil)
                    return
            }
        }
    }
    
    func presentError(error:Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
}
