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
        self.term = term.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        super.init()
    }
    
    func search(type: SearchType, time: SearchTimeType = .week, completion: ((Bool)->Void)? = nil) {
        do {
            let realm = try Realm()
            if realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term):\(time.rawValue)") == nil {
                try realm.write {
                    let result = SearchResult()
                    result.id = "search:\(self.term):\(time.rawValue)"
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
            self.searchPhotos(time: time, completion: completion)
        case .discussions:
            self.searchDiscussions(time: time, completion: completion)
        case .videos:
            self.searchVideos(time: time, completion: completion)
        case .links:
            self.searchLinks(time: time, completion: completion)
        case .subreddits:
            self.searchSubreddits(time: time, completion: completion)
        }
    }
    
    func searchPhotos(time: SearchTimeType = .week, completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestSearch(type: .photos, time: time) { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term):\(time.rawValue)")
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
    
    func searchDiscussions(time: SearchTimeType = .week, completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestSearch(type: .discussions, time: time) { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term):\(time.rawValue)")
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
    
    func searchVideos(time: SearchTimeType = .week, completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestSearch(type: .videos, time: time) { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term):\(time.rawValue)")
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
    
    func searchLinks(time: SearchTimeType = .week, completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestSearch(type: .links, time: time) { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term):\(time.rawValue)")
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
    
    func searchSubreddits(time: SearchTimeType = .week, completion: ((Bool)->Void)? = nil) {
        let term = self.term
        self.requestSearch(type: .subreddits, time: time) { (json: [[String:Any]]?) in
            guard let guardedJSON = json else {
                guard let completion = completion else { return }
                return completion(false)
            }
            do {
                let realm = try Realm()
                let result = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(term):\(time.rawValue)")
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
    
    func requestSearch(type: SearchType, time: SearchTimeType = .week, completion: @escaping ([[String:Any]]?)->Void) {
        var urlString = ""
        switch type {
        case .photos:
            urlString = "search/photos"
        case .videos:
            urlString = "search/videos"
        case .links:
            urlString = "search/links"
        case .discussions:
            urlString = "search/discussions"
        case .subreddits:
            urlString = "search/subreddits"
        }
        let url = URL(string: urlString, relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .query(key: "term", item: term)
            .query(key: "time", item: time.rawValue)
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
