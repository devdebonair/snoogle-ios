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
    
    func set(term: String, time: SearchTimeType = .week) {
        self.term = term.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.time = time
    }
    
    func fetchSubreddits() {
        ServiceSearch(term: term).search(type: .subreddits, time: time) { [weak self] (success) in
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
        ServiceSearch(term: term).search(type: .discussions, time: time) { [weak self] (success) in
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
        ServiceSearch(term: term).search(type: .photos, time: time) { [weak self] (success) in
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
