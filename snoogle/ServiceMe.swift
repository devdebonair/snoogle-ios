//
//  ServiceMe.swift
//  snoogle
//
//  Created by Vincent Moore on 3/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class ServiceMe: Service {
    
    override init() {}
    
    func fetch(completion: ((Bool)->Void)? = nil) {
        requestFetch { (json: [String : Any]?) in
            guard let json = json, let account = Account(JSON: json) else {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(account, update: true)
                }
            } catch {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            guard let completion = completion else { return }
            return completion(true)
        }
    }
    
    func multireddits(completion: ((Bool)->Void)? = nil) {
        requestMultireddits { (json: [[String : Any]]?) in
            guard let json = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            do {
                let realm = try Realm()
                try realm.write {
                    for multiJSON in json {
                        guard let multireddit = Multireddit(JSON: multiJSON) else { continue }
                        realm.add(multireddit, update: true)
                    }
                }
            } catch {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            guard let completion = completion else { return }
            return completion(true)
        }
    }
    
    func subscriptions(completion: ((Bool)->Void)? = nil) {
        requestSubscriptions { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func trophies(completion: ((Bool)->Void)? = nil) {
        requestTrophies { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func friends(completion: ((Bool)->Void)? = nil) {
        requestFriends { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func blocked(completion: ((Bool)->Void)? = nil) {
        requestBlocked { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func inbox(completion: ((Bool)->Void)? = nil) {
        requestInbox { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func unread(completion: ((Bool)->Void)? = nil) {
        requestUnread { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func privateMessages(completion: ((Bool)->Void)? = nil) {
        requestPrivateMessages { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func commentReplies(completion: ((Bool)->Void)? = nil) {
        requestCommentReplies { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func submissionReplies(completion: ((Bool)->Void)? = nil) {
        requestSubmissionReplies { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func mentions(completion: ((Bool)->Void)? = nil) {
        requestMentions { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func sent(completion: ((Bool)->Void)? = nil) {
        requestSent { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
}

extension ServiceMe {
    func requestFetch(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me", relativeTo: base)!
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
    
    func requestMultireddits(completion: @escaping ([[String:Any]]?)->Void) {
        let url = URL(string: "me/multireddits", relativeTo: base)!
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
    
    func requestSubscriptions(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/subscriptions", relativeTo: base)!
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
    
    func requestTrophies(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/trophies", relativeTo: base)!
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
    
    func requestFriends(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/friends", relativeTo: base)!
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
    
    func requestBlocked(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/blocked", relativeTo: base)!
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
    
    func requestInbox(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/inbox", relativeTo: base)!
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
    
    func requestUnread(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/inbox/unread", relativeTo: base)!
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
    
    func requestPrivateMessages(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/inbox/private", relativeTo: base)!
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
    
    func requestCommentReplies(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/inbox/replies/comments", relativeTo: base)!
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
    
    func requestSubmissionReplies(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/inbox/replies/submissions", relativeTo: base)!
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
    
    func requestMentions(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/inbox/mentions", relativeTo: base)!
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
    
    func requestSent(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "me/inbox/sent", relativeTo: base)!
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
}
