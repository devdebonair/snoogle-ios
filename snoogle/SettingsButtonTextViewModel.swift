//
//  SettingsButton.swift
//  snoogle
//
//  Created by Vincent Moore on 8/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsButtonTextViewModel: NSObject, ViewModelElement {
    var text: String = ""
    var didSelect: (()->Void)? = nil
    
    deinit {
        didSelect = nil
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeText()
        cell.textNode.attributedText = NSMutableAttributedString(
            string: self.text,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()
            ])
        cell.inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        cell.hasSeparator = true
        cell.separatorColor = ThemeManager.background()
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cell.backgroundColor = ThemeManager.cellBackground()
        return cell
    }
    
    func didSelect(index: Int) {
        if let didSelect = didSelect {
            didSelect()
        }
    }
}
