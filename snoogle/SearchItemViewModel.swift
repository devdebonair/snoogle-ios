//
//  SearchItemViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/28/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol SearchItemViewModelDelegate {
    func didSelectSearchItem(searchItem: SearchItemViewModel)
}

class SearchItemViewModel: NSObject, ViewModelElement {
    enum CellType: Int {
        case separator = 0
        case cell = 1
    }
    
    let text: String
    let cellOrder: [CellType] = [.cell]
    
    var delegate: SearchItemViewModelDelegate? = nil
    
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
            cell.separator.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
            return cell
        case .cell:
            let cell = CellNodeButtonTextLeft()
            cell.textNode.attributedText = NSMutableAttributedString(
                string: text,
                attributes: [
                    NSForegroundColorAttributeName: UIColor(red: 44/255, green: 45/255, blue: 48/255, alpha: 1.0),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
                ])
            cell.imageNode.image = #imageLiteral(resourceName: "search")
            cell.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor(red: 44/255, green: 45/255, blue: 48/255, alpha: 1.0))
            cell.backgroundColor = .white
            cell.inset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            return cell
        }
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        delegate.didSelectSearchItem(searchItem: self)
    }
}
