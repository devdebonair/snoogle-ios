//
//  SettingsCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol SettingsCollectionControllerDelegate {
    func didSelectSwitchAccounts()
}

class SettingsCollectionController: CollectionController {
    var delegate: SettingsCollectionControllerDelegate? = nil
    
    override func viewDidLoad() {
        let switchAccounts = SettingsTextViewModel()
        switchAccounts.text = "Switch Accounts"
        switchAccounts.didSelect = {
            guard let delegate = self.delegate else { return }
            delegate.didSelectSwitchAccounts()
        }
        
        let clearCache = SettingsTextViewModel()
        clearCache.text = "Free Up Space"
        clearCache.didSelect = {
            print("selected cache")
        }
        
        let changeTheme = SettingsTextViewModel()
        changeTheme.text = "Change Theme"
        changeTheme.didSelect = {
            print("changing theme")
        }
        
        let safeMode = SettingsSwitchViewModel()
        safeMode.text = "Safe Mode"
        
        let spoilers = SettingsSwitchViewModel()
        spoilers.text = "Spoilers"
        
        self.models = [switchAccounts, clearCache, changeTheme, safeMode, spoilers]
        self.updateModels()
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.node.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBar.hide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StatusBar.show()
    }
}
