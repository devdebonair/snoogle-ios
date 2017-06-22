//
//  StatusBar.swift
//  snoogle
//
//  Created by Vincent Moore on 6/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

struct StatusBar {
    static var statusBar: UIView? {
        return UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
    }
    
    static func set(color: UIColor) {
        guard let statusBar = StatusBar.statusBar else { return }
        statusBar.backgroundColor = color
    }
}
