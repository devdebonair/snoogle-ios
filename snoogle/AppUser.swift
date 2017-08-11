//
//  AppUser.swift
//  snoogle
//
//  Created by Vincent Moore on 8/7/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

class AppUser: Object {
    
    enum AppUserError: Error {
        case invalidUser
        case invalidAccount
    }
    
    dynamic var activeAccount: Account?
    var accounts = List<Account>()
    var subredditRecent = List<Subreddit>()
    var subredditFavorites = List<Subreddit>()
    
    static func addAccount(name: String, isActive: Bool = false) throws {
        let realm = try Realm()
        let app = realm.objects(AppUser.self).first
        let account = Query<Account>().key("name").eqlStr(name).exec(realm: realm).first
        guard let guardedApp = app else { throw AppUserError.invalidUser }
        guard let guardedAccount = account else { throw AppUserError.invalidAccount }
        try realm.write {
            guardedApp.accounts.append(guardedAccount)
            print(isActive)
            if isActive {
                guardedApp.activeAccount = guardedAccount
            }
        }
    }
    
    static func getActiveAccount() throws -> Account? {
        let realm = try Realm()
        return AppUser.getActiveAccount(realm: realm)
    }
    
    static func getActiveAccount(realm: Realm) -> Account? {
        return realm.objects(AppUser.self).first?.activeAccount
    }
}
