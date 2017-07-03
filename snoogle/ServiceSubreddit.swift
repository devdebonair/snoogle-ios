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

class ServiceSubreddit: Service {
    
    var name: String
    
    init(name: String) {
        self.name = name
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
        
        self.requestListing { (json: [String:Any]?) in
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
            print("crashing initial")
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
                
                try realm.write {
                    for subJSON in submissionJSON {
                        guard let submission = Submission(JSON: subJSON) else { continue }
                        guardedListing.submissions.append(submission)
                    }
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
}

// Network
extension ServiceSubreddit {
    func requestFetch(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)", relativeTo: base)!
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
    
    func requestListing(sort: ListingSort = .hot, after: String? = nil, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/listing/\(sort.rawValue)", relativeTo: base)!
        var network = Network()
            .get()
            .url(url)
        
        if let after = after {
            network = network.query(key: "after", item: after)
        }
        
        network.parse(type: .json)
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
    
    func requestUnsubscribe(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/unsubscribe", relativeTo: base)!
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
    
    func requestSubmitText(title: String, text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "subreddit/\(name)/submit/text", relativeTo: base)!
        Network().post().url(url)
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
        Network()
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
}
