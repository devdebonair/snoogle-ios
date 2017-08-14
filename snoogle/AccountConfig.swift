//
//  AccountConfig.swift
//  snoogle
//
//  Created by Vincent Moore on 8/13/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class AccountConfig: Object {
    enum AccountConfigError: Error {
        case invalidConfig
        case invalidSubreddit
    }

    enum ListType: Int {
        case recent = 0
        case favorites = 1
    }
    
    dynamic var id: String = ""
    
    var subredditRecent = List<Subreddit>()
    var subredditFavorites = List<Subreddit>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func isFavorited(subreddit: String, realm: Realm) throws -> Bool {
        guard let sub = Subreddit.getBy(name: subreddit, realm: realm) else { throw AccountConfigError.invalidSubreddit }
        return self.isFavorited(subreddit: sub)
    }

    func isFavorited(subreddit: Subreddit) -> Bool {
        return self.subredditFavorites.contains(subreddit)
    }
    
    func add(subreddit: String, to: ListType) throws {
        let realm = try Realm()
        try realm.write {
            try self.add(subreddit: subreddit, to: to, realm: realm)
        }
    }
    
    func add(subreddit: String, to: ListType, realm: Realm) throws {
        guard let sub = Subreddit.getBy(name: subreddit, realm: realm) else { throw AccountConfigError.invalidSubreddit }
        switch to {
        case .favorites:
            guard !self.subredditFavorites.contains(sub) else { return }
            self.subredditFavorites.append(sub)
        case .recent:
            if let index = self.subredditRecent.index(of: sub) {
                self.subredditRecent.remove(objectAtIndex: index)
            }
            self.subredditRecent.insert(sub, at: 0)
        }
    }
    
    func remove(subreddit: String, from: ListType) throws {
        let realm = try Realm()
        try realm.write {
            try self.remove(subreddit: subreddit, from: from, realm: realm)
        }
    }
    
    func remove(subreddit: String, from: ListType, realm: Realm) throws {
        guard let sub = Subreddit.getBy(name: subreddit, realm: realm) else { throw AccountConfigError.invalidSubreddit }
        switch from {
        case .favorites:
            if let index = self.subredditFavorites.index(of: sub) {
                self.subredditFavorites.remove(objectAtIndex: index)
            }
        case .recent:
            if let index = self.subredditRecent.index(of: sub) {
                self.subredditRecent.remove(objectAtIndex: index)
            }
        }
    }
}

// Statics
extension AccountConfig {
    static func getConfig(for account: String, realm: Realm) -> AccountConfig? {
        return realm.object(ofType: AccountConfig.self, forPrimaryKey: "config:\(account.trimmedLowercase())")
    }
    
    static func create(for account: String, realm: Realm) {
        let config = AccountConfig()
        config.id = "config:\(account.trimmedLowercase())"
        realm.add(config)
    }
}
