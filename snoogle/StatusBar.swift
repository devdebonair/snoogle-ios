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
    
    static func hide() {
        guard let statusBar = StatusBar.statusBar else { return }
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveLinear], animations: {
            statusBar.frame.origin.y -= statusBar.frame.height
        }, completion: nil)
    }
    
    static func show() {
        guard let statusBar = StatusBar.statusBar else { return }
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveEaseOut], animations: {
            statusBar.frame.origin.y += statusBar.frame.height
        }, completion: nil)
    }
}
