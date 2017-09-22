//
//  SettingsTextIconStateViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsTextIconStateViewModel: NSObject, ViewModelElement {
    var text: String = ""
    var didSelect: (()->Void)? = nil
    var cell: CellNodeTextIcon? = nil
    
    var colorEnabled = UIColor(red: 206/255, green: 224/255, blue: 239/255, alpha: 1.0)
    var colorDisabled = UIColor(red: 224/255, green: 224/255, blue: 228/255, alpha: 1.0)
    var colorActive: UIColor {
        return isSelected ? colorEnabled : colorDisabled
    }
    
    var imageEnabled: UIImage? = nil
    var imageDisabled: UIImage? = nil
    var imageActive: UIImage? {
        return self.isSelected ? imageEnabled : imageDisabled
    }
    
    var isSelected: Bool = false {
        didSet {
            if let cell = cell {
                let color = self.isSelected ? self.colorEnabled : self.colorDisabled
                let image = self.isSelected ? self.imageEnabled : self.imageDisabled
                cell.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
                cell.imageNode.image = nil
                cell.imageNode.image = image
            }
        }
    }
    
    deinit {
        didSelect = nil
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeTextIcon()
        cell.imageNode.image = imageActive
        cell.textNode.attributedText = NSMutableAttributedString(
            string: self.text,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold),
                NSForegroundColorAttributeName: UIColor(red: 45/255, green: 46/255, blue: 48/255, alpha: 1.0)
            ])
        cell.imageNode.contentMode = .scaleAspectFit
        cell.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(colorActive)
        cell.imageNode.style.preferredSize = CGSize(width: 25, height: 25)
        cell.inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 30)
        cell.hasSeparator = true
        cell.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 228/255, alpha: 0.3)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cell.backgroundColor = .white
        self.cell = cell
        return cell
    }
    
    func didSelect(index: Int) {
        self.isSelected = !self.isSelected
        if let didSelect = didSelect {
            didSelect()
        }
    }
}
