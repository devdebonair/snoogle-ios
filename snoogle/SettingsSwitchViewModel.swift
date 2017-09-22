//
//  SettingsSwitchViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsSwitchViewModel: NSObject, ViewModelElement {
    var text: String = ""
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeTextSwitch()
        cell.textNode.attributedText = NSMutableAttributedString(
            string: self.text,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: UIColor(red: 45/255, green: 46/255, blue: 48/255, alpha: 1.0)
            ])
        cell.inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.hasSeparator = true
        cell.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 228/255, alpha: 0.3)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cell.switchView.isOn = true
        cell.switchView.onTintColor = UIColor(red: 206/255, green: 224/255, blue: 239/255, alpha: 1.0)
        cell.switchView.backgroundColor = .clear
        cell.backgroundColor = .white
        return cell
    }
}
