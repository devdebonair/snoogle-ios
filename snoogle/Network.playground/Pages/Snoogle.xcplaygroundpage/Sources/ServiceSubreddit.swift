//
//  ServiceSubreddit.swift
//  snoogle
//
//  Created by Vincent Moore on 3/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceSubreddit: Service {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func fetch(completion: ((Bool)->Void)? = nil) {
        requestFetch { (json: [String : Any]?) in
            if let json = json, let subreddit = Subreddit(JSON: json) {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(subreddit, update: true)
                    }
                    if let completion = completion { return completion(true) }
                } catch {
                    if let completion = completion { return completion(false) }
                }
            } else if let completion = completion {
                return completion(false)
            }
        }
    }
    
    func listing(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        let name = self.name
        let this = self
        
        this.fetch { (success: Bool) in
            this.requestListing { (json: [String:Any]?) in
                do {
                    let realm = try Realm()
                    let sub = Query<Subreddit>().key("displayName").eqlStr(name).exec(realm: realm).first
                    guard let newSub = sub, let json = json, let submissionJSON = json["data"] as? [[String:Any]] else {
                        if let completion = completion { return completion(false) }
                        return
                    }
                    try realm.write {
                        let listing = ListingSubreddit()
                        listing.id = ListingSubreddit.createId(subId: newSub.id, sort: sort)
                        listing.subreddit = newSub
                        listing.sort = sort.rawValue
                        listing.submissions.removeAll()
                        for subJSON in submissionJSON {
                            let submission = Submission(JSON: subJSON)
                            if let submission = submission {
                                listing.submissions.append(submission)
                            }
                        }
                        realm.add(listing, update: true)
                        if let completion = completion { return completion(true) }
                    }
                } catch {
                    if let completion = completion { return completion(false) }
                }
            }
        }
    }
    
    func moreListings(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        let name = self.name
        var listing: ListingSubreddit? = nil
        var after: String? = nil
        
        do {
            let realm = try Realm()
            let sub = Query<Subreddit>().key("displayName").eqlStr(name).exec(realm: realm).first
            if let sub = sub {
                listing = realm.object(ofType: ListingSubreddit.self, forPrimaryKey: ListingSubreddit.createId(subId: sub.id, sort: sort))
            }
        } catch {
            if let completion = completion { return completion(false) }
        }
        
        after = listing?.after
        
        guard let guardedAfter = after else {
            if let completion = completion { return completion(false) }
            return
        }
        
        requestListing(sort: sort, after: guardedAfter) { (json: [String:Any]?) in
            do {
                let realm = try Realm()
                let sub = Query<Subreddit>().key("displayName").eqlStr(name).exec(realm: realm).first
                
                guard let guardedSub = sub, let listing = realm.object(ofType: ListingSubreddit.self, forPrimaryKey: ListingSubreddit.createId(subId: guardedSub.id, sort: sort)), let json = json, let submissionJSON = json["data"] as? [[String:Any]] else {
                    if let completion = completion { return completion(false) }
                    return
                }
                
                try realm.write {
                    for subJSON in submissionJSON {
                        let submission = Submission(JSON: subJSON)
                        if let submission = submission {
                            listing.submissions.append(submission)
                        }
                    }
                }
                if let completion = completion { return completion(true) }
            } catch {
                if let completion = completion { return completion(false) }
            }
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
