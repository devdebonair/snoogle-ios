//
//  TagViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/16/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class TagViewModel: NSObject, ViewModelElement {
    var text: String = ""
    var colorBackground: UIColor = .black
    var colorText: UIColor = .white
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let attributes = NSMutableAttributedString(
            string: self.text,
            attributes: [
                NSForegroundColorAttributeName: self.colorText,
                NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightMedium)
        ])
        let cell = CellNodeText { (cell) in
//            cell.cornerRadius = 3.0
        }
        cell.textNode.attributedText = attributes
        cell.inset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        cell.backgroundColor = self.colorBackground
        return cell
    }
}
