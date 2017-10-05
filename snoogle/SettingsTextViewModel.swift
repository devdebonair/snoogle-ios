//
//  SettingsTextViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsTextViewModel: NSObject, ViewModelElement, ThemableElement {
    var text: String = ""
    var didSelect: (()->Void)? = nil
    var cell: CellNode? = nil
    
    deinit {
        didSelect = nil
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeText()
        cell.inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.hasSeparator = true
        cell.separatorColor = ThemeManager.background()
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.setTheme(cell: cell)
        self.cell = cell
        return cell
    }
    
    func setTheme(cell: CellNodeText) {
        cell.textNode.attributedText = NSMutableAttributedString(
            string: self.text,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()
            ])
        cell.separatorColor = ThemeManager.background()
        cell.backgroundColor = ThemeManager.cellBackground()
    }
    
    func configureTheme() {
        guard let cell = cell as? CellNodeText else { return }
        UIView.animate(withDuration: 0.8) {
            self.setTheme(cell: cell)
        }
    }
    
    func didSelect(index: Int) {
        if let didSelect = didSelect {
            didSelect()
        }
    }
}

