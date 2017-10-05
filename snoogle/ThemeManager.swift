//
//  ThemeManager.swift
//  snoogle
//
//  Created by Vincent Moore on 9/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import ChameleonFramework

typealias Style = ThemeManager

final class ThemeManager {
    
    static let NOTIFICATION_NAME = "SnoogleThemeChange"
    
    static var backgroundColor: UIColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    static var colorCellBackground: UIColor = .white
    static var colorTextPrimary: UIColor = UIColor(red: 44/255, green: 45/255, blue: 48/255, alpha: 1.0)
    static var colorTextSecondary: UIColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
    static var colorNavigation: UIColor = background()
    static var colorToolbar: UIColor = background()
    static var colorToolbarItem: UIColor = navigationItem()
    static var colorNavigationItem: UIColor = textPrimary()
    static var colorCellAccessory: UIColor = .flatGrayDark
    
    static func setup() {
        Chameleon.setGlobalThemeUsingPrimaryColor(primary(), withSecondaryColor: secondary(), andContentStyle: content())
    }
    
    static func primary() -> UIColor {
        return .white
    }
    
    static func secondary() -> UIColor {
        return .clear
    }
    
    static func background() -> UIColor {
        return backgroundColor
    }
    
    static func cellBackground() -> UIColor {
        return colorCellBackground
    }
    
    static func cellAccessory() -> UIColor {
        return colorCellAccessory
    }
    
    static func toolbar() -> UIColor {
        return colorToolbar
    }
    
    static func toolbarItem() -> UIColor {
        return colorToolbarItem
    }
    
    static func navigation() -> UIColor {
        return colorNavigation
    }
    
    static func navigationItem() -> UIColor {
        return colorNavigationItem
    }
    
    static func textPrimary() -> UIColor {
        return colorTextPrimary
    }
    
    static func textSecondary() -> UIColor {
        return colorTextSecondary
    }
    
    static func content() -> UIContentStyle {
        return .contrast
    }
    
    static func font() -> String {
        return UIFont.systemFont(ofSize: 16).fontName
    }
    
    static func sendThemeChangeNotification() {
        let name = Notification.Name(rawValue: NOTIFICATION_NAME)
        NotificationCenter.default.post(Notification(name: name))
    }
    
    static func receiveNotifications(target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: Notification.Name(rawValue: ThemeManager.NOTIFICATION_NAME), object: nil)
    }
}
