//
//  SearchItemViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/28/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SearchItemViewModel: NSObject, ViewModelElement {
    enum CellType: Int {
        case separator = 0
        case cell = 1
    }
    
    let text: String
    let cellOrder: [CellType] = [.cell]
    
    init(text: String = "") {
        self.text = text
        super.init()
    }
    
    func numberOfCells() -> Int {
        return cellOrder.count
    }
    
    func cell(index: Int) -> ASCellNode {
        let cellType = cellOrder[index]
        switch cellType {
        case .separator:
            let cell = CellNodeSeparator()
            cell.separator.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
            return cell
        case .cell:
            let cell = CellNodeButtonTextLeft()
            cell.textNode.attributedText = NSMutableAttributedString(
                string: text,
                attributes: [
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
                ])
            cell.imageNode.image = #imageLiteral(resourceName: "search")
            cell.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0))
            cell.backgroundColor = .white
            return cell
        }
    }
    
    func didSelect(index: Int) {
        print("selected \(text)")
    }
}
