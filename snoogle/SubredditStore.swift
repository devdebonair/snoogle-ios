//
//  SubredditStore.swift
//  snoogle
//
//  Created by Vincent Moore on 7/3/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol SubredditStoreDelegate {
    func didUpdatePosts(submissions: List<Submission>)
    func didUpdateSubreddit(subreddit: Subreddit)
}

class SubredditStore {
    var delegate: SubredditStoreDelegate? = nil
    var tokenSubreddit: RLMNotificationToken? = nil
    var tokenListing: RLMNotificationToken? = nil
    private var sort: ListingSort = .hot
    private var name: String = ""
    
    func setSubreddit(name: String) {
        self.name = name
        self.tokenListing = nil
        self.tokenSubreddit = nil
        DispatchQueue.global(qos: .background).async {
            ServiceSubreddit(name: name).fetch(completion: { [weak self] (success) in
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        let subreddit = Query<Subreddit>().key("displayName").eqlStr(name).exec(realm: realm).first
                        guard let guardedSubreddit = subreddit, let delegate = weakSelf.delegate else { return }
                        weakSelf.tokenSubreddit = guardedSubreddit.addNotificationBlock({ (_) in
                            delegate.didUpdateSubreddit(subreddit: guardedSubreddit)
                        })
                        delegate.didUpdateSubreddit(subreddit: guardedSubreddit)
                    } catch {
                        print(error)
                    }
                }
            })
        }
    }
    
    func setSort(sort: ListingSort) {
        self.sort = sort
        self.fetchListing(refresh: true)
    }
    
    func fetchListing(refresh: Bool = false) {
        DispatchQueue.global(qos: .background).async {
            if let _ = self.tokenListing, !refresh {
                return ServiceSubreddit(name: self.name).moreListings(sort: self.sort)
            }
            ServiceSubreddit(name: self.name).listing(sort: self.sort) { [weak self] (success) in
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        let listing = realm.object(ofType: ListingSubreddit.self, forPrimaryKey: "listing:\(weakSelf.name):\(weakSelf.sort.rawValue)")
                        guard let guardedListing = listing, let delegate = weakSelf.delegate else { return }
                        weakSelf.tokenListing = guardedListing.addNotificationBlock({ (_) in
                            delegate.didUpdatePosts(submissions: guardedListing.submissions)
                        })
                        delegate.didUpdatePosts(submissions: guardedListing.submissions)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func upvote(id: String) {
        DispatchQueue.global(qos: .background).async {
            do {
                ServiceSubmission(id: id).upvote()
                let realm = try Realm()
                let submission = realm.object(ofType: Submission.self, forPrimaryKey: id)
                if let submission = submission {
                    try realm.write {
                        submission.ups = submission.ups + 1
                        submission.score = submission.score + 1
                        submission.likes.value = true
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func downvote(id: String) {
        DispatchQueue.global(qos: .background).async {
            do {
                ServiceSubmission(id: id).downvote()
                let realm = try Realm()
                let submission = realm.object(ofType: Submission.self, forPrimaryKey: id)
                if let submission = submission {
                    try realm.write {
                        submission.ups = submission.ups - 1
                        submission.score = submission.score - 1
                        submission.likes.value = false
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func save(id: String) {
        DispatchQueue.global(qos: .background).async {
            do {
                ServiceSubmission(id: id).save()
                let realm = try Realm()
                let submission = realm.object(ofType: Submission.self, forPrimaryKey: id)
                if let submission = submission {
                    try realm.write {
                        submission.saved = true
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func unsave(id: String) {
        DispatchQueue.global(qos: .background).async {
            do {
                ServiceSubmission(id: id).unsave()
                let realm = try Realm()
                let submission = realm.object(ofType: Submission.self, forPrimaryKey: id)
                if let submission = submission {
                    try realm.write {
                        submission.saved = false
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func unvote(id: String) {
        DispatchQueue.global(qos: .background).async {
            ServiceSubmission(id: id).unvote()
            do {
                let realm = try Realm()
                let submission = realm.object(ofType: Submission.self, forPrimaryKey: id)
                if let submission = submission {
                    try realm.write {
                        if let likes = submission.likes.value, likes {
                            submission.ups = submission.ups - 1
                            submission.score = submission.score - 1
                        }
                        if let likes = submission.likes.value, !likes {
                            submission.ups = submission.ups + 1
                            submission.score = submission.score + 1
                        }
                        submission.likes.value = nil
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
