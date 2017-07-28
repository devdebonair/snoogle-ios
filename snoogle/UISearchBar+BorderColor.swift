//
//  UISearchBar+BorderColor.swift
//  snoogle
//
//  Created by Vincent Moore on 7/28/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func setBorder(color: UIColor) {
        for s in self.subviews[0].subviews {
            if s is UITextField {
                s.layer.borderWidth = 1.0
                s.layer.borderColor = color.cgColor
                s.layer.cornerRadius = 5.0
            }
        }
    }
}
