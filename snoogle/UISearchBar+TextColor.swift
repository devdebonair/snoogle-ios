//
//  UISearchBar+TextColor.swift
//  snoogle
//
//  Created by Vincent Moore on 10/2/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    // https://stackoverflow.com/questions/28499701/how-can-i-change-the-uisearchbar-search-text-color
    func setText(color: UIColor) {
        guard let textField = self.value(forKey: "searchField") as? UITextField else { return }
        textField.textColor = color
    }
}
