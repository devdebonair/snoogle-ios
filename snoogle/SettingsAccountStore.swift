//
//  SettingsAccountStore.swift
//  snoogle
//
//  Created by Vincent Moore on 8/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol SettingsAccountStoreDelegate {
    func didChangeActiveAccount(account: Account?)
    func didChangeAccounts(accounts: List<Account>, active: Account?)
}

class SettingsAccountStore {
    private var activeAccountToken: RLMNotificationToken? = nil
    private var accountsToken: RLMNotificationToken? = nil
    var delegate: SettingsAccountStoreDelegate? = nil
    
    func getApp() {
        do {
            let realm = try Realm()
            guard let app = realm.objects(AppUser.self).first else { return }
            self.accountsToken = app.accounts.addNotificationBlock({ (_) in
                guard let delegate = self.delegate else { return }
                delegate.didChangeAccounts(accounts: app.accounts, active: app.activeAccount)
            })
            self.activeAccountToken = app.activeAccount?.addNotificationBlock({ (_) in
                guard let delegate = self.delegate else { return }
                delegate.didChangeActiveAccount(account: app.activeAccount)
            })
        } catch {
            print(error)
        }
    }
    
    func setAccount(name: String) {
        let strippedName = name.trimmedLowercase()
        do {
            let realm = try Realm()
            guard let app = realm.objects(AppUser.self).first else { return }
            let account = app.accounts.first { (account) -> Bool in
                return account.name.trimmedLowercase() == strippedName
            }
            guard let guardedAccount = account else { return }
            try realm.write {
                app.activeAccount = guardedAccount
            }
        } catch {
            print(error)
        }
    }
}
