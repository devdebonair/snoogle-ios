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
    func didSetToFrontpage()
    func didClear()
}

class SubredditStore {
    var delegate: SubredditStoreDelegate? = nil
    var tokenSubreddit: RLMNotificationToken? = nil
    var tokenListing: RLMNotificationToken? = nil
    private var tokenApp: RLMNotificationToken? = nil
    private var sort: ListingSort = .hot
    private var name: String = ""
    private var user: String? = nil
    private var source: FeedSource = .subreddit
    
    enum FeedSource: Int {
        case frontpage = 0
        case subreddit = 1
        case all = 2
        case popular = 3
    }
    
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
    
    func setSubreddit(name: String, source: FeedSource = .subreddit) {
        guard let user = user else { return }
        
        self.name = name
        self.sort = .hot
        self.source = source
        self.tokenListing = nil
        self.tokenSubreddit = nil
        
        if source == .frontpage {
            self.name = ""
            guard let delegate = delegate else { return }
            delegate.didSetToFrontpage()
        }
        
        if source == .subreddit {
            DispatchQueue.global(qos: .background).async {
                ServiceSubreddit(name: name, user: user).fetch(completion: { [weak self] (success) in
                    guard let weakSelf = self else { return }
                    DispatchQueue.main.async {
                        do {
                            let realm = try Realm()
                            realm.refresh()
                            let subreddit = Query<Subreddit>().key("displayName").eqlStr(name).exec(realm: realm).first
                            guard let guardedSubreddit = subreddit else { return }
                            try AccountConfig.add(subreddit: weakSelf.name, to: .recent, for: user)
                            guard let delegate = weakSelf.delegate else { return }
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
    }
    
    func setSort(sort: ListingSort) {
        guard sort != self.sort else { return }
        self.sort = sort
        self.fetchListing(refresh: true)
    }
    
    func fetchListing(refresh: Bool = false) {
        guard let user = user else { return }
        
        if let _ = self.tokenListing, !refresh {
            
            if source == .frontpage {
                DispatchQueue.global(qos: .background).async {
                    ServiceFrontpage(user: user).moreListings(sort: self.sort)
                }
            }
            
            if source == .subreddit {
                DispatchQueue.global(qos: .background).async {
                    ServiceSubreddit(name: self.name, user: user).moreListings(sort: self.sort)
                }
            }
        } else {
            
            if source == .frontpage {
                DispatchQueue.main.async {
                    ServiceFrontpage(user: user).listing(sort: self.sort) { [weak self] (success) in
                        DispatchQueue.main.async {
                            guard let weakSelf = self else { return }
                            do {
                                let realm = try Realm()
                                realm.refresh()
                                let listing = realm.object(ofType: ListingFrontpage.self, forPrimaryKey: "frontpage:\(user):\(weakSelf.sort.rawValue)")
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
            
            if source == .subreddit {
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
    }
    
    func clear() {
        guard let delegate = delegate else { return }
        self.name = ""
        self.tokenListing?.stop()
        self.tokenSubreddit?.stop()
        self.tokenSubreddit = nil
        self.tokenListing = nil
        self.sort = .hot
        self.source = .subreddit
        delegate.didClear()
    }
    
    func upvote(id: String) {
        guard let user = user else { return }
        
        DispatchQueue.global(qos: .background).async {
            do {
                ServiceSubmission(id: id, user: user).upvote()
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
        guard let user = user else { return }
        
        DispatchQueue.global(qos: .background).async {
            do {
                ServiceSubmission(id: id, user: user).downvote()
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
        guard let user = user else { return }
        
        DispatchQueue.global(qos: .background).async {
            do {
                ServiceSubmission(id: id, user: user).save()
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
        guard let user = user else { return }
        DispatchQueue.global(qos: .background).async {
            do {
                ServiceSubmission(id: id, user: user).unsave()
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
        guard let user = user else { return }
        DispatchQueue.global(qos: .background).async {
            ServiceSubmission(id: id, user: user).unvote()
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
    
    func addToFavorites() {
        guard let user = user else { return }
        do {
            try AccountConfig.add(subreddit: self.name, to: .favorites, for: user)
        } catch {
            print(error)
        }
    }
    
    func subscribe() {
        guard let user = user else { return }
        ServiceSubreddit(name: self.name, user: user).subscribe()
        do {
            let realm = try Realm()
            guard let account = AppUser.getActiveAccount(realm: realm) else { return }
            try realm.write {
                try account.subscribe(to: self.name, realm: realm)
            }
        } catch {
            print(error)
        }
    }
    
    func unsubscribe() {
        guard let user = user else { return }
        ServiceSubreddit(name: self.name, user: user).unsubscribe()
        do {
            let realm = try Realm()
            guard let account = AppUser.getActiveAccount(realm: realm) else { return }
            try realm.write {
                try account.unsubscribe(from: self.name, realm: realm)
            }
        } catch {
            print(error)
        }
    }
    
    func isSubscribed() -> Bool {
        do {
            guard let isSubscribed = try AppUser.getActiveAccount()?.isSubscribed(to: self.name) else { return false}
            return isSubscribed
        } catch {
            return false
        }
    }
}
