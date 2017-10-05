//
//  UISearchBar+CancelColor.swift
//  snoogle
//
//  Created by Vincent Moore on 10/2/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func setCancel(color: UIColor) {
        guard let cancelButton = self.value(forKey: "cancelButton") as? UIButton else { return }
        cancelButton.setTitleColor(color, for: [])
    }
}
