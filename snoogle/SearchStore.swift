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
    func didUpdateResults(result: SearchResult)
}

class SearchStore {
    var delegate: SearchStoreDelegate? = nil
    var time: SearchTimeType = .week
    var term: String = ""
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
    
    func set(term: String, time: SearchTimeType = .week) {
        self.term = term.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.time = time
    }
    
    func fetchSubreddits() {
        guard let user = user else { return }
        ServiceSearch(term: term, user: user).search(type: .subreddits, time: time) { [weak self] (success) in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                do {
                    let realm = try Realm()
                    let searchResult = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(weakSelf.term):\(weakSelf.time.rawValue)")
                    guard let guardedSearchResult = searchResult else { return }
                    weakSelf.delegate?.didUpdateResults(result: guardedSearchResult)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func fetchDiscussions() {
        guard let user = user else { return }
        
        ServiceSearch(term: term, user: user).search(type: .discussions, time: time) { [weak self] (success) in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                do {
                    let realm = try Realm()
                    let searchResult = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(weakSelf.term):\(weakSelf.time.rawValue)")
                    guard let guardedSearchResult = searchResult else { return }
                    weakSelf.delegate?.didUpdateResults(result: guardedSearchResult)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func fetchPhotos() {
        guard let user = user else { return }
        
        ServiceSearch(term: term, user: user).search(type: .photos, time: time) { [weak self] (success) in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                do {
                    let realm = try Realm()
                    let searchResult = realm.object(ofType: SearchResult.self, forPrimaryKey: "search:\(weakSelf.term):\(weakSelf.time.rawValue)")
                    guard let guardedSearchResult = searchResult else { return }
                    weakSelf.delegate?.didUpdateResults(result: guardedSearchResult)
                } catch {
                    print(error)
                }
            }
        }
    }
}
