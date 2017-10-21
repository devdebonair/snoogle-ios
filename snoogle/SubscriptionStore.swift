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
    private var tokenActiveAccount: RLMNotificationToken? = nil
    private var tokenSubscriptions: RLMNotificationToken? = nil
    private var tokenRecent: RLMNotificationToken? = nil
    private var tokenMultireddits: RLMNotificationToken? = nil
    private var tokenFavorites: RLMNotificationToken? = nil
    
    func setAccount() {
        do {
            let realm = try Realm()
            if tokenActiveAccount == nil {
                guard let app = realm.objects(AppUser.self).first else { return }
                self.tokenActiveAccount = app.observe({ (changeType) in
                    switch changeType {
                    case .change(let properties):
                        for property in properties {
                            if property.name == "activeAccount" {
                                self.setAccount()
                            }
                        }
                    case .deleted:
                        return
                    case .error:
                        return
                    }
                })
            }
            guard let account = AppUser.getActiveAccount(realm: realm) else { return }
            guard let config = AccountConfig.getConfig(for: account.name, realm: realm) else { return }
            self.delegate?.didUpdateSubscriptions(subreddits: account.subredditSubscriptions)
            self.delegate?.didUpdateMultireddits(multireddits: account.multireddits)
            self.delegate?.didUpdateRecent(subreddits: config.subredditRecent)
            self.delegate?.didUpdateFavorites(subreddits: config.subredditFavorites)
            self.tokenSubscriptions = account.subredditSubscriptions.observe({ (_) in
                self.delegate?.didUpdateSubscriptions(subreddits: account.subredditSubscriptions)
            })
            self.tokenMultireddits = account.subredditSubscriptions.observe({ (_) in
                self.delegate?.didUpdateMultireddits(multireddits: account.multireddits)
            })
            self.tokenFavorites = config.subredditFavorites.observe({ (_) in
                self.delegate?.didUpdateFavorites(subreddits: config.subredditFavorites)
            })
            self.tokenRecent = config.subredditRecent.observe({ (_) in
                self.delegate?.didUpdateRecent(subreddits: config.subredditRecent)
            })
            ServiceMe(user: account.name).fetch()
        } catch {
            print(error)
        }
    }
}
