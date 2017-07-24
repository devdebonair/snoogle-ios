//
//  ServiceSearch.swift
//  snoogle
//
//  Created by Vincent Moore on 7/23/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceSearch: Service {
    enum SearchType: Int {
        case photos = 0
        case discussions = 1
        case videos = 2
        case links = 3
        case subreddits = 4
    }
    
    let term: String
    
    init(term: String) {
        self.term = term
        super.init()
    }
    
    func search(type: SearchType, completion: ((Bool)->Void)? = nil) {
        do {
            let realm = try Realm()
            if realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(self.term)") == nil {
                try realm.write {
                    let result = SearchResult()
                    result.id = "search:\(self.term)"
                    result.term = self.term
                    realm.add(result)
                }
            }
        } catch {
            guard let completion = completion else { return }
            return completion(false)
        }
        switch type {
        case .photos:
            self.searchPhotos(completion: completion)
        case .discussions:
            self.searchDiscussions(completion: completion)
        case .videos:
            self.searchVideos(completion: completion)
        case .links:
            self.searchLinks(completion: completion)
        case .subreddits:
            self.searchSubreddits(completion: completion)
        }
    }
    
    func searchPhotos(completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestPhotos() { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term)")
                guard let guardedResult = result else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                var submissions = [Submission]()
                for subJSON in guardedJSON {
                    if let submission = Submission(JSON: subJSON) {
                        submissions.append(submission)
                    }
                }
                try realm.write {
                    realm.add(submissions, update: true)
                    guardedResult.photos.removeAll()
                    guardedResult.photos.append(objectsIn: submissions)
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
    
    func searchDiscussions(completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestDiscussions() { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term)")
                guard let guardedResult = result else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                var submissions = [Submission]()
                for subJSON in guardedJSON {
                    if let submission = Submission(JSON: subJSON) {
                        submissions.append(submission)
                    }
                }
                try realm.write {
                    realm.add(submissions, update: true)
                    guardedResult.discussions.removeAll()
                    guardedResult.discussions.append(objectsIn: submissions)
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
    
    func searchVideos(completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestVideos() { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term)")
                guard let guardedResult = result else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                var submissions = [Submission]()
                for subJSON in guardedJSON {
                    if let submission = Submission(JSON: subJSON) {
                        submissions.append(submission)
                    }
                }
                try realm.write {
                    realm.add(submissions, update: true)
                    guardedResult.videos.removeAll()
                    guardedResult.videos.append(objectsIn: submissions)
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
    
    func searchLinks(completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestLinks() { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term)")
                guard let guardedResult = result else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                var submissions = [Submission]()
                for subJSON in guardedJSON {
                    if let submission = Submission(JSON: subJSON) {
                        submissions.append(submission)
                    }
                }
                try realm.write {
                    realm.add(submissions, update: true)
                    guardedResult.links.removeAll()
                    guardedResult.links.append(objectsIn: submissions)
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
    
    func searchSubreddits(completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestSubreddits() { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term)")
                guard let guardedResult = result else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                var subreddits = [Subreddit]()
                for subJSON in guardedJSON {
                    if let subreddit = Subreddit(JSON: subJSON) {
                        subreddits.append(subreddit)
                    }
                }
                try realm.write {
                    realm.add(subreddits, update: true)
                    guardedResult.subreddits.removeAll()
                    guardedResult.subreddits.append(objectsIn: subreddits)
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

    func requestPhotos(completion: @escaping ([[String:Any]]?)->Void) {
        let url = URL(string: "search/photos", relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .query(key: "term", item: term)
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
    
    func requestDiscussions(completion: @escaping ([[String:Any]]?)->Void) {
        let url = URL(string: "search/discussions", relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .query(key: "term", item: term)
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
    
    func requestVideos(completion: @escaping ([[String:Any]]?)->Void) {
        let url = URL(string: "search/videos", relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .query(key: "term", item: term)
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
    
    func requestLinks(completion: @escaping ([[String:Any]]?)->Void) {
        let url = URL(string: "search/links", relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .query(key: "term", item: term)
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
    
    func requestSubreddits(completion: @escaping ([[String:Any]]?)->Void) {
        let url = URL(string: "search/subreddits", relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .query(key: "term", item: term)
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
}
