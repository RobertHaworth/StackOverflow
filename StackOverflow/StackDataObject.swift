//
//  StackDataObject.swift
//  StackOverflow
//
//  Created by Robert Haworth on 5/18/17.
//  Copyright © 2017 Robert Haworth. All rights reserved.
//

import UIKit

class StackDataObject {
    
    private(set) var id:Int?
    
    var link:String? {
        get {
            return dataDictionary["link"] as? String
        }
    }
    
    var title:NSAttributedString? {
        get {
            guard let HTMLString = dataDictionary["title"] as? String else {
                return nil
            }
            
            return htmlString(HTMLString: HTMLString)
        }
    }
    
    var authorName:String? {
        get {
            return owner?.name
        }
    }
    
    var tags:[String]? {
        get {
            return dataDictionary["tags"] as? Array<String>
        }
    }
    
    var body:NSAttributedString? {
        get {
            guard let HTMLString = dataDictionary["body"] as? String else {
                return nil
            }
            
            return htmlString(HTMLString: HTMLString)
        }
    }
    
    var owner:User?

    var dataDictionary:Dictionary<String, AnyObject>
    
    init(dictionary:Dictionary<String, AnyObject>) {
        dataDictionary = dictionary
        consumeOwner()
    }
    
    private func consumeOwner() {
        guard let ownerDictionary = dataDictionary["owner"] as? Dictionary<String, AnyObject> else {
            print("unable to find owner")
            return
        }
        owner = User(userDict: ownerDictionary)
    }
    
    private func htmlString(HTMLString:String) -> NSAttributedString? {
        let data = HTMLString.data(using: String.Encoding.unicode)
        
        do {
            let string = try NSAttributedString(data: data!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            
            return string
        } catch let error as NSError {
            print("unable to convert body to attributed string for HTML string interpolation \n \(error)")
            return nil
        }
    }
}
