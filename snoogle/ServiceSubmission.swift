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

class ServiceSubmission: ServiceReddit {
    
    var id = ""
    
    init(id: String, user: String) {
        self.id = id
        super.init(user: user)
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
    
    func getComments(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        requestGetComments(sort: sort) { (json: [[String : Any]]?) in
            guard let json = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let jsonToSave: [String:Any] = [
                    "name": self.id,
                    "sort": sort.rawValue,
                    "comments": json
                ]
                guard let comments = SubmissionComments(JSON: jsonToSave) else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                try realm.write {
                    realm.add(comments, update: true)
                }
            } catch {
                if let completion = completion { return completion(false) }
            }
            if let completion = completion { return completion(true) }
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
    
    func requestGetComments(sort: ListingSort = .hot, completion: @escaping ([[String:Any]]?)->Void) {
        let url = URL(string: "submissions/\(id)/comments/\(sort.rawValue)", relativeTo: base)!
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
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
