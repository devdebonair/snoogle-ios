//
//  SearchStore.swift
//  snoogle
//
//  Created by Vincent Moore on 7/23/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol SearchStoreDelegate {
    func didUpdateSubreddits(subreddits: List<Subreddit>)
}

class SearchStore {
    var delegate: SearchStoreDelegate? = nil
    var tokenSubreddit: RLMNotificationToken? = nil
    private var term: String = ""
    
    func set(term: String) {
        self.term = term
        self.tokenSubreddit = nil
    }
    
    func fetchSubreddits() {
        ServiceSearch(term: term).search(type: .subreddits) { [weak self] (success) in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                do {
                    let realm = try Realm()
                    let searchResult = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(weakSelf.term)")
                    guard let guardedSearchResult = searchResult else { return }
                    weakSelf.tokenSubreddit = guardedSearchResult.addNotificationBlock({ (_) in
                        weakSelf.delegate?.didUpdateSubreddits(subreddits: guardedSearchResult.subreddits)
                    })
                    weakSelf.delegate?.didUpdateSubreddits(subreddits: guardedSearchResult.subreddits)
                } catch {
                    print(error)
                }
            }
        }
    }
}
