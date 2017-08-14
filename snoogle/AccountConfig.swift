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
    
    static func add(subreddit: String, to: ListType, for account: String) throws {
        let realm = try Realm()
        try AccountConfig.add(subreddit: subreddit, to: to, for: account, realm: realm)
    }
    
    // TODO: Check for performance optimizatin by requiring fuction to be called under write transaction
    static func add(subreddit: String, to: ListType, for account: String, realm: Realm) throws {
        let config = AccountConfig.getConfig(for: account, realm: realm)
        let subreddit = Query<Subreddit>().key("displayName").eqlStr(subreddit).exec(realm: realm).first
        guard let guardedConfig = config else { throw AccountConfigError.invalidConfig }
        guard let guardedSubreddit = subreddit else { throw AccountConfigError.invalidSubreddit }
        switch to {
        case .favorites:
            guard !guardedConfig.subredditFavorites.contains(guardedSubreddit) else { return }
            try realm.write {
                guardedConfig.subredditFavorites.append(guardedSubreddit)
            }
        case .recent:
            try realm.write {
                let index = guardedConfig.subredditRecent.index(of: guardedSubreddit)
                guard let guardedIndex = index else {
                    return guardedConfig.subredditRecent.insert(guardedSubreddit, at: 0)
                }
                guardedConfig.subredditRecent.remove(objectAtIndex: guardedIndex)
                guardedConfig.subredditRecent.insert(guardedSubreddit, at: 0)
            }
        }
    }
    
    static func getConfig(for account: String, realm: Realm) -> AccountConfig? {
        let accountTrimmed = account.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return realm.object(ofType: AccountConfig.self, forPrimaryKey: "config:\(accountTrimmed)")
    }
    
    // TODO: Should be called in write transaction
    static func create(for account: String, realm: Realm) {
        let accountTrimmed = account.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let config = AccountConfig()
        config.id = "config:\(accountTrimmed)"
        realm.add(config)
    }
}
