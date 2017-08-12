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
    func didClear()
}

class SubredditStore {
    var delegate: SubredditStoreDelegate? = nil
    var tokenSubreddit: RLMNotificationToken? = nil
    var tokenListing: RLMNotificationToken? = nil
    private var sort: ListingSort = .hot
    private var name: String = ""
    private var user: String? = nil
    private var tokenApp: RLMNotificationToken? = nil
    
    init() {
        do {
            let realm = try Realm()
            let apps = realm.objects(AppUser.self)
            self.tokenApp = apps.addNotificationBlock({ (_) in
                self.user = AppUser.getActiveAccount(realm: realm)?.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            })
            guard let app = apps.first else { return }
            self.user = app.activeAccount?.name
        } catch {
            print(error)
        }
    }
    
    func setSubreddit(name: String) {
        guard let user = user else { return }
        
        self.name = name
        self.sort = .hot
        self.tokenListing = nil
        self.tokenSubreddit = nil
        
        DispatchQueue.global(qos: .background).async {
            ServiceSubreddit(name: name, user: user).fetch(completion: { [weak self] (success) in
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        realm.refresh()
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
        guard sort != self.sort else { return }
        self.sort = sort
        self.fetchListing(refresh: true)
    }
    
    func fetchListing(refresh: Bool = false) {
         guard let user = user else { return }
        
        if let _ = self.tokenListing, !refresh {
            DispatchQueue.global(qos: .background).async {
                ServiceSubreddit(name: self.name, user: user).moreListings(sort: self.sort)
            }
        } else {
            // This is ok to do on the main thread because it is the first fetch
            // This is to avoid the issue where realm is changed on background thread
            //      and we alert the controller before main thread is updated.
            DispatchQueue.main.async {
                ServiceSubreddit(name: self.name, user: user).listing(sort: self.sort) { [weak self] (success) in
                    DispatchQueue.main.async {
                        guard let weakSelf = self else { return }
                        do {
                            let realm = try Realm()
                            realm.refresh()
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
    }
    
    func clear() {
        guard let delegate = delegate else { return }
        self.name = ""
        self.tokenListing?.stop()
        self.tokenSubreddit?.stop()
        self.tokenSubreddit = nil
        self.tokenListing = nil
        self.sort = .hot
        delegate.didClear()
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
