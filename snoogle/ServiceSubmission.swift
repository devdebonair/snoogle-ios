//
//  ServiceSubmission.swift
//  snoogle
//
//  Created by Vincent Moore on 3/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper_Realm

class ServiceSubmission: Service {
    
    var id = ""
    
    init(id: String) {
        self.id = id
    }
    
    func fetch(completion: ((Bool)->Void)? = nil) {
        requestFetch { (json: [String : Any]?) in
            if let json = json, let submission = Submission(JSON: json) {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(submission, update: true)
                    }
                    if let completion = completion { return completion(true) }
                } catch {
                    if let completion = completion { return completion(false) }
                }
            }
            if let completion = completion { return completion(false) }
        }
    }
    
    func getComments(completion: ((Bool)->Void)? = nil) {
        requestGetComments { (json: [[String : Any]]?) in
            if let json = json {
                do {
                    let realm = try Realm()
                    let submission = realm.object(ofType: Submission.self, forPrimaryKey: self.id)
                    guard let guardedSubmission = submission else {
                        //TODO: Get submission
                        print("we were not able to get the stuff")
                        if let completion = completion { return completion(false) }
                        return
                    }
                    let comments = List<Comment>()
                    for dictionary in json {
                        if let comment = Comment(JSON: dictionary) {
                            comments.append(comment)
                        }
                    }
                    print(comments.count)
                    try realm.write {
                        guardedSubmission.comments.removeAll()
                        guardedSubmission.comments.append(contentsOf: comments)
                    }
                    if let completion = completion { return completion(true) }
                } catch {
                    if let completion = completion { return completion(false) }
                }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func upvote(completion: ((Bool)->Void)? = nil) {
        requestUpvote { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func downvote(completion: ((Bool)->Void)? = nil) {
        requestDownvote { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func save(completion: ((Bool)->Void)? = nil) {
        requestSave { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func unvote(completion: ((Bool)->Void)? = nil) {
        requestUnvote { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func unsave(completion: ((Bool)->Void)? = nil) {
        requestUnsave { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func hide(completion: ((Bool)->Void)? = nil) {
        requestHide { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func unhide(completion: ((Bool)->Void)? = nil) {
        requestUnhide { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    // check why contenttype needs to be specified.
    func reply(text: String, completion: ((Bool)->Void)? = nil) {
        requestReply(text: text) { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    // check why contenttype needs to be specified.
    func edit(text: String, completion: ((Bool)->Void)? = nil) {
        requestEdit(text: text) { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func delete(completion: ((Bool)->Void)? = nil) {
        requestDelete { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
}

extension ServiceSubmission {
    func requestFetch(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)", relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestGetComments(completion: @escaping ([[String:Any]]?)->Void) {
        let url = URL(string: "submissions/\(id)/comments", relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .success() { (data, response) in
                return completion(data as? [[String:Any]])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestUpvote(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)/upvote", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestDownvote(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)/downvote", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestSave(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)/save", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestUnvote(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)/unvote", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestUnsave(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)/unsave", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestHide(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)/hide", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestUnhide(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)/unhide", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    // check why contenttype needs to be specified.
    func requestReply(text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)/reply", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .contentType(type: .json)
            .body(add: "text", value: text)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    // check why contenttype needs to be specified.
    func requestEdit(text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)", relativeTo: base)!
        Network()
            .put()
            .url(url)
            .contentType(type: .json)
            .body(add: "text", value: text)
            .parse(type: .json)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
    
    func requestDelete(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "submissions/\(id)", relativeTo: base)!
        Network()
            .delete()
            .url(url)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
}
