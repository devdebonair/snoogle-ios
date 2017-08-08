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
            let account = realm.object(ofType: Account.self, forPrimaryKey: id)
            if let account = account {
                self.delegate?.didUpdateSubscriptions(subreddits: account.subredditSubscriptions)
                self.delegate?.didUpdateMultireddits(multireddits: account.multireddits)
            }
        } catch {
            print(error)
        }
        
        DispatchQueue.global(qos: .background).async {
            ServiceMe().fetch { [weak self](success) in
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        realm.refresh()
                        let account = realm.object(ofType: Account.self, forPrimaryKey: id)
                        guard let guardedAccount = account else { return }
                        weakSelf.tokenSubscriptions = guardedAccount.subredditSubscriptions.addNotificationBlock({ (_) in
                            weakSelf.delegate?.didUpdateSubscriptions(subreddits: guardedAccount.subredditSubscriptions)
                        })
                        weakSelf.tokenMultireddits = guardedAccount.subredditSubscriptions.addNotificationBlock({ (_) in
                            weakSelf.delegate?.didUpdateMultireddits(multireddits: guardedAccount.multireddits)
                        })
                        weakSelf.delegate?.didUpdateSubscriptions(subreddits: guardedAccount.subredditSubscriptions)
                        weakSelf.delegate?.didUpdateMultireddits(multireddits: guardedAccount.multireddits)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
