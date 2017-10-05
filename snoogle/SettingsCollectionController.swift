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
    var backgroundColor: UIColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let switchAccounts = SettingsTextViewModel()
        switchAccounts.text = "Switch Accounts"
        switchAccounts.didSelect = {
            guard let delegate = self.delegate else { return }
            delegate.didSelectSwitchAccounts()
        }
        switchAccounts.receiveThemeChanges()
        
        let clearCache = SettingsTextViewModel()
        clearCache.text = "Free Up Space"
        clearCache.didSelect = {
            print("selected cache")
        }
        clearCache.receiveThemeChanges()
        
        let changeTheme = SettingsTextViewModel()
        changeTheme.text = "Change Theme"
        changeTheme.didSelect = {
            ThemeManager.backgroundColor = UIColor.flatBlack.darken(byPercentage: 0.05)!
            ThemeManager.colorCellBackground = .flatBlack
            ThemeManager.colorTextPrimary = .flatWhite
            ThemeManager.colorTextSecondary = .flatWhite
            ThemeManager.colorNavigation = ThemeManager.colorCellBackground
            ThemeManager.colorNavigationItem = .flatWhite
            ThemeManager.colorToolbar = ThemeManager.colorCellBackground
            ThemeManager.colorToolbarItem = UIColor.flatGrayDark
            ThemeManager.colorCellAccessory = UIColor.flatGrayDark
            ThemeManager.sendThemeChangeNotification()
        }
        changeTheme.receiveThemeChanges()
        
        let safeMode = SettingsSwitchViewModel()
        safeMode.text = "Safe Mode"
        safeMode.receiveThemeChanges()
        
        let spoilers = SettingsSwitchViewModel()
        spoilers.text = "Spoilers"
        spoilers.receiveThemeChanges()
        
        self.models = [switchAccounts, clearCache, changeTheme, safeMode, spoilers]
        self.updateModels()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
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
