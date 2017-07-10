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
    func didUpdateMultireddits(multireddit: List<Multireddit>)
    func didUpdateFavorites(subreddits: List<Subreddit>)
    func didSelectSubreddit(subreddit: Subreddit)
}

class SubscriptionStore {
    var delegate: SubscriptionStoreDelegate? = nil
    private var tokenSubscriptions: RLMNotificationToken?? = nil
    private var tokenRecent: RLMNotificationToken? = nil
    private var tokenMultireddits: RLMNotificationToken? = nil
    private var tokenFavorites: RLMNotificationToken? = nil
    
    func setAccount(id: String) {
        DispatchQueue.global(qos: .background).async {
            ServiceMe().fetch { [weak self](success) in
                print(success)
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        let account = realm.object(ofType: Account.self, forPrimaryKey: id)
                        guard let guardedAccount = account else { return }
                        weakSelf.tokenSubscriptions = guardedAccount.subredditSubscriptions.addNotificationBlock({ (_) in
                            weakSelf.delegate?.didUpdateSubscriptions(subreddits: guardedAccount.subredditSubscriptions)
                        })
                        weakSelf.tokenRecent = guardedAccount.subredditSubscriptions.addNotificationBlock({ (_) in
                            weakSelf.delegate?.didUpdateRecent(subreddits: guardedAccount.subredditRecent)
                        })
                        weakSelf.tokenMultireddits = guardedAccount.subredditSubscriptions.addNotificationBlock({ (_) in
                            weakSelf.delegate?.didUpdateMultireddits(multireddit: guardedAccount.multireddits)
                        })
                        weakSelf.tokenFavorites = guardedAccount.subredditSubscriptions.addNotificationBlock({ (_) in
                            weakSelf.delegate?.didUpdateFavorites(subreddits: guardedAccount.subredditFavorites)
                        })
                        weakSelf.delegate?.didUpdateSubscriptions(subreddits: guardedAccount.subredditSubscriptions)
                        weakSelf.delegate?.didUpdateRecent(subreddits: guardedAccount.subredditRecent)
                        weakSelf.delegate?.didUpdateMultireddits(multireddit: guardedAccount.multireddits)
                        weakSelf.delegate?.didUpdateFavorites(subreddits: guardedAccount.subredditFavorites)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
