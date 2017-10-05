//
//  ThemableElement.swift
//  snoogle
//
//  Created by Vincent Moore on 9/26/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation

@objc protocol ThemableElement: class {
    func configureTheme()
}


extension ThemableElement {
    func receiveThemeChanges() {
        ThemeManager.receiveNotifications(target: self, selector: #selector(configureTheme))
    }
}
