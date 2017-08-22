//
//  SettingsAccountsController.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsAccountsController: CollectionController {
    override func viewDidLoad() {
        let switchAccounts = SettingsTextViewModel()
        switchAccounts.text = "catalystlive"
        switchAccounts.didSelect = {
            print("selected catalystlive")
        }
        
        let clearCache = SettingsTextViewModel()
        clearCache.text = "devdebonair"
        clearCache.didSelect = {
            print("selected devdebonair")
        }
        
        self.models = [switchAccounts, clearCache]
        self.updateModels()
    }
}
