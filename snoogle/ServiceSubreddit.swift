//
//  ServiceSubreddit.swift
//  snoogle
//
//  Created by Vincent Moore on 3/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ServiceSubreddit: ServiceReddit {
    
    var name: String
    
    init(name: String, user: String) {
        self.name = name
        super.init(user: user)
    }
    
    func fetch(completion: ((Bool)->Void)? = nil) {
        requestFetch { (json: [String : Any]?) in
            guard let json = json, let subreddit = Subreddit(JSON: json) else {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(subreddit, update: true)
                }
            } catch {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            guard let completion = completion else { return }
            return completion(true)
        }
    }
    
    func listing(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        let name = self.name
        
        self.requestListing(sort: sort, after: nil) { (json: [String:Any]?) in
            guard let json = json, let submissionJSON = json["data"] as? [[String:Any]] else {
                guard let completion = completion else { return }
                return completion(false)
            }
            let jsonToSave: [String:Any] = [
                "name": name,
                "sort": sort.rawValue,
                "submissions": submissionJSON
            ]
            
            guard let listing = ListingSubreddit(JSON: jsonToSave) else {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(listing, update: true)
                }
            } catch {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            guard let completion = completion else { return }
            return completion(true)
        }
    }
    
    func moreListings(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        let name = self.name
        var listing: ListingSubreddit? = nil
        
        do {
            let realm = try Realm()
            let listingId = "listing:\(name):\(sort.rawValue)"
            listing = realm.object(ofType: ListingSubreddit.self, forPrimaryKey: listingId)
        } catch {
            print(error)
            guard let completion = completion else { return }
            return completion(false)
        }
        
        guard let _ = listing, let guardedAfter = listing?.after else {
            return self.listing(sort: sort, completion: completion)
        }
        
        requestListing(sort: sort, after: guardedAfter) { (json: [String:Any]?) in
            guard let json = json, let submissionJSON = json["data"] as? [[String:Any]] else {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            do {
                let realm = try Realm()
                let listingId = "listing:\(name):\(sort.rawValue)"
                let listing = realm.object(ofType: ListingSubreddit.self, forPrimaryKey: listingId)
                
                guard let guardedListing = listing else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                
                var toDelete = [Submission]()
                var toAdd = [Submission]()
                for subJSON in submissionJSON {
                    guard let submission = Submission(JSON: subJSON) else { continue }
                    let existingSubmission = realm.object(ofType: Submission.self, forPrimaryKey: submission.id)
                    if let existingSubmission = existingSubmission {
                        toDelete.append(existingSubmission)
                    }
                    toAdd.append(submission)
                }
                
                try realm.write {
                    realm.delete(toDelete)
                    guardedListing.submissions.append(objectsIn: toAdd)
                }
            } catch {
                print(error)
                guard let completion = completion else { return }
                return completion(false)
            }
            
            guard let completion = completion else { return }
            return completion(true)
        }
    }
    
    func subscribe(completion: ((Bool)->Void)? = nil) {
        requestSubscribe { (json: [String:Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func unsubscribe(completion: ((Bool)->Void)? = nil) {
        requestUnsubscribe { (json: [String:Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func submitText(title: String, text: String, completion: ((Bool)->Void)? = nil) {
        requestSubmitText(title: title, text: text) { (json: [String : Any]?) in
            if let json = json, let name = json["name"] as? String {
                let id = name[3..<name.characters.count-1]
                ServiceSubmission(id: id).fetch()
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func submitLink(title: String, link: URL, completion: ((Bool)->Void)? = nil) {
        requestSubmitLink(title: title, link: link) { (json: [String : Any]?) in
            if let json = json, let name = json["name"] as? String {
                let id = name[3..<name.characters.count-1]
                ServiceSubmission(id: id).fetch()
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func fetchActivity(completion: ((Bool)->Void)? = nil) {
        requestActivity { (json: [String:Any]?) in
            guard let json = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let activity = SubredditActivity(JSON: json)
                guard let guardedActivity = activity else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                try realm.write {
                    realm.add(guardedActivity, update: true)
                }
            } catch {
                print(error)
                guard let completion = completion else { return }
                return completion(false)
            }
            guard let completion = completion else { return }
            return completion(true)
        }
    }
}

// Network
extension ServiceSubreddit {
    func requestFetch(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)", relativeTo: base)!
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
    
    func requestListing(sort: ListingSort = .hot, after: String? = nil, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/listing/\(sort.rawValue)", relativeTo: base)!
        guard let network = self.oauthRequest() else { return completion(nil) }
        let _ = network
                .get()
                .url(url)
        
        if let after = after {
            let _ = network.query(key: "after", item: after)
        }
        
        network
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
    
    func requestSubscribe(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/subscribe", relativeTo: base)!
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
    
    func requestUnsubscribe(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/unsubscribe", relativeTo: base)!
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
    
    func requestSubmitText(title: String, text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/submit/text", relativeTo: base)!
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
            .post()
            .url(url)
            .body(add: "title", value: title)
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
    
    func requestSubmitLink(title: String, link: URL, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/submit/link", relativeTo: base)!
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
            .post()
            .url(url)
            .body(add: "title", value: title)
            .body(add: "url", value: link.absoluteString)
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
    
    func requestActivity(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/activity", relativeTo: base)!
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
            .error() { (error: Error) in
                return completion(nil)
            }
            .sendHTTP()
    }
}
