//
//  SubredditPageStore.swift
//  snoogle
//
//  Created by Vincent Moore on 8/3/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

protocol SubredditPageStoreDelegate {
    func didFetchSubreddit(subreddit: Subreddit)
    func didFetchActivity(activity: SubredditActivity)
}

class SubredditPageStore {
    var delegate: SubredditPageStoreDelegate? = nil
    var user: String? = nil
    
    init() {
        do {
            self.user = try AppUser.getActiveAccount()?.name
        } catch {
            print(error)
        }
    }

    func fetchSubreddit(name: String) {
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                let subreddit = Query<Subreddit>().key("displayName").eqlStr(name).exec(realm: realm).first
                guard let guardedSubreddit = subreddit, let delegate = self.delegate else { return }
                delegate.didFetchSubreddit(subreddit: guardedSubreddit)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchActivity(name: String) {
        guard let user = user else { return }
        ServiceSubreddit(name: name, user: user).fetchActivity(completion: { [weak self] (success) in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                do {
                    let realm = try Realm()
                    realm.refresh()
                    let activity = realm.object(ofType: SubredditActivity.self, forPrimaryKey: "\(name):activity")
                    guard let guardedActivity = activity, let delegate = weakSelf.delegate else { return }
                    delegate.didFetchActivity(activity: guardedActivity)
                } catch {
                    print(error)
                }
            }
        })
    }
}
