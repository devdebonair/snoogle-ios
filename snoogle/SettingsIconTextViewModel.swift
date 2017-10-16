//
//  SettingsIconTextViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 10/7/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SettingsIconTextViewModel: NSObject, ViewModelElement {
    var spacing: CGFloat = 0.0
    var didSelect: ((SettingsIconTextViewModel)->Void)? = nil
    var icon: ASDisplayNode? = nil
    let textNode = ASTextNode()
    
    deinit {
        didSelect = nil
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeStack()
        cell.hasSeparator = true
        cell.separatorColor = ThemeManager.background()
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cell.inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        cell.stack.spacing = spacing
        cell.backgroundColor = ThemeManager.cellBackground()
        cell.stack.alignContent = .center
        cell.stack.alignItems = .center
        if let icon = icon {
            cell.stack.children?.append(icon)
        }
        cell.stack.children?.append(textNode)
        return cell
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func didSelect(index: Int) {
        guard let didSelect = didSelect else { return }
        didSelect(self)
    }
}
