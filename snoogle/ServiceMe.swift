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
            // implement
        }
    }
    
    func multireddits(completion: ((Bool)->Void)? = nil) {
        // Strategy to prevent overwrites from inconsistent data.
        // Reddit does not return the full subreddit json
        // This is needed because the keys in Subreddit do not match keys
        //      the keys returned by the api. snake_case -> camelCase
        let extractSubreddits = { (json: [String:Any]) -> [String : Any] in
            var jsonToMerge = [String:Any]()
            jsonToMerge["iconImage"] = json["icon_img"]
            jsonToMerge["bannerImage"] = json["banner_img"]
            jsonToMerge["description"] = json["description"]
            jsonToMerge["displayName"] = json["display_name"]
            jsonToMerge["publicDescription"] = json["public_description"]
            jsonToMerge["name"] = json["name"]
            jsonToMerge["subscribers"] = json["subscribers"]
            jsonToMerge["keyColor"] = json["key_color"]
            jsonToMerge["subredditType"] = json["subreddit_type"]
            jsonToMerge["headerImage"] = json["header_img"]
            if let name = jsonToMerge["name"] as? String {
                jsonToMerge["id"] = Subreddit.getId(from: name)
            }
            return jsonToMerge
        }
        
        requestMultireddits { (json: [[String : Any]]?) in
            if let json = json {
                do {
                    let realm = try Realm()
                    try realm.write {
                        for multiJSON in json {
                            if let multi = Multireddit(JSON: multiJSON), let subs = multiJSON["subreddits"] as? [[String:Any]] {
                                realm.add(multi, update: true)
                                multi.subreddits.removeAll()
                                for subJSON in subs {
                                    let extractedSubJSON = extractSubreddits(subJSON)
                                    let id = extractedSubJSON["id"]
                                    let existingSub = realm.object(ofType: Subreddit.self, forPrimaryKey: id)
                                    if let _ = id, let _ = existingSub {
                                        let updatedSub = realm.create(Subreddit.self, value: extractedSubJSON, update: true)
                                        multi.subreddits.append(updatedSub)
                                    } else {
                                        if let newSub = Subreddit(JSON: subJSON) {
                                            multi.subreddits.append(newSub)
                                        }
                                    }
                                }
                            }
                        }
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
