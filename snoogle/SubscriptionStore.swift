//
//  SubscriptionStore.swift
//  snoogle
//
//  Created by Vincent Moore on 7/8/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol SubscriptionStoreDelegate {
    func didUpdateSubscriptions(subreddits: List<Subreddit>)
    func didUpdateRecent(subreddits: List<Subreddit>)
    func didUpdateMultireddits(multireddits: List<Multireddit>)
    func didUpdateFavorites(subreddits: List<Subreddit>)
}

class SubscriptionStore {
    var delegate: SubscriptionStoreDelegate? = nil
    private var tokenSubscriptions: RLMNotificationToken?? = nil
    private var tokenRecent: RLMNotificationToken? = nil
    private var tokenMultireddits: RLMNotificationToken? = nil
    private var tokenFavorites: RLMNotificationToken? = nil
    
    func setAccount(id: String) {
        do {
            let realm = try Realm()
            guard let account = AppUser.getActiveAccount(realm: realm) else { return }
            self.delegate?.didUpdateSubscriptions(subreddits: account.subredditSubscriptions)
            self.delegate?.didUpdateMultireddits(multireddits: account.multireddits)
            self.tokenSubscriptions = account.subredditSubscriptions.addNotificationBlock({ (_) in
                self.delegate?.didUpdateSubscriptions(subreddits: account.subredditSubscriptions)
            })
            self.tokenMultireddits = account.subredditSubscriptions.addNotificationBlock({ (_) in
                self.delegate?.didUpdateMultireddits(multireddits: account.multireddits)
            })
            self.delegate?.didUpdateSubscriptions(subreddits: account.subredditSubscriptions)
            self.delegate?.didUpdateMultireddits(multireddits: account.multireddits)

            ServiceMe(user: account.name).fetch()
        } catch {
            print(error)
        }
    }
}
