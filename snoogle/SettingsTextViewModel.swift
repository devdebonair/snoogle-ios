//
//  SettingsTextViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsTextViewModel: NSObject, ViewModelElement {
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
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 45/255, green: 46/255, blue: 48/255, alpha: 1.0)
            ])
        cell.inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.hasSeparator = true
        cell.separatorColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 228/255, alpha: 0.3)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cell.backgroundColor = .white
        return cell
    }
    
    func didSelect(index: Int) {
        if let didSelect = didSelect {
            didSelect()
        }
    }
}

