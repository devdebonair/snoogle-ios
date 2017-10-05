//
//  SettingsSwitchViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsSwitchViewModel: NSObject, ViewModelElement, ThemableElement {
    var text: String = ""
    var cell: CellNodeTextSwitch? = nil
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeTextSwitch { (cell) in
            guard let cell = cell as? CellNodeTextSwitch else { return }
            cell.switchView.isOn = true
            cell.switchView.onTintColor = ThemeManager.cellAccessory()
            cell.switchView.backgroundColor = .clear
        }
        cell.inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.hasSeparator = true
        cell.separatorColor = ThemeManager.background()
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        setTheme(cell: cell)
        self.cell = cell
        return cell
    }
    
    func setTheme(cell: CellNodeTextSwitch) {
        cell.textNode.attributedText = NSMutableAttributedString(
            string: self.text,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()
            ])
        cell.backgroundColor = ThemeManager.cellBackground()
        cell.separatorColor = ThemeManager.background()
    }
    
    func configureTheme() {
        guard let cell = cell else { return }
        UIView.animate(withDuration: 0.8) {
            self.setTheme(cell: cell)
        }
    }
}
