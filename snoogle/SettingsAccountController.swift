//
//  SettingsAccountController.swift
//  snoogle
//
//  Created by Vincent Moore on 8/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import Realm
import RealmSwift
import SafariServices
import KeychainSwift

class SettingsAccountController: CollectionController, SettingsAccountStoreDelegate {
    let store = SettingsAccountStore()
    let notification = Notification.Name(rawValue: "RedditAuthToken")
    var safariController: SFSafariViewController? = nil
    
    init() {
        super.init()
        store.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeActiveAccount(account: Account?) {
        print("we changed active account")
    }
    
    func didChangeAccounts(accounts: List<Account>) {
        let models = accounts.map { (account) -> SettingsTextViewModel in
            let model = SettingsTextViewModel()
            model.text = account.name.trimmedLowercase()
            model.didSelect = {
                self.store.setAccount(name: account.name)
            }
            return model
        }
        self.models = Array(models)
        let addAccountModel = SettingsButtonTextViewModel()
        addAccountModel.text = "Add Account"
        addAccountModel.didSelect = {
            let url = URL(string: URL_AUTHENTICATION )
            guard let guardedUrl = url else { return }
            let controller = SFSafariViewController(url: guardedUrl)
            self.safariController = controller
            self.present(controller, animated: true, completion: nil)
        }
        self.models.append(addAccountModel)
        self.updateModels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Accounts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.didTapDone))
        self.node.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        store.getApp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAuthToken), name: notification, object: nil)
    }
    
    func didReceiveAuthToken(notification: Notification) {
        guard let code = notification.object as? String else { return }
        self.safariController?.dismiss(animated: true, completion: nil)
        self.safariController = nil
        ServiceRedditAuth().fetchTokens(code: code) { (name) in
            guard let name = name else { return }
            let nameStripped = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            ServiceMe(user: nameStripped).fetch(completion: { (success) in
                if success {
                    do {
                        try AppUser.addAccount(name: name, isActive: false)
                    } catch {
                        print(error)
                    }
                } else {
                    print("an error occured")
                }
            })
        }
    }
    
    func didTapDone() {
        self.dismiss(animated: true, completion: nil)
    }
}
