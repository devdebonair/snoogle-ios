//
//  MenuItemViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MenuItemViewModel: NSObject, ViewModelElement {
    let image: UIImage
    let text: NSMutableAttributedString
    let didSelect: ()->Void
    
    init(image: UIImage, text: NSMutableAttributedString, didSelect: @escaping ()->Void) {
        self.image = image
        self.text = text
        self.didSelect = didSelect
        super.init()
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeButtonTextLeft()
        cell.imageNode.image = image
        cell.textNode.attributedText = text
        cell.inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        cell.imageSize = 20
        cell.imageNode.contentMode = .scaleAspectFit
        cell.spacing = 20
        return cell
    }
    
    func cellSize(at index: Int, context: IGListCollectionContext) -> ASSizeRange {
        let size = CGSize(width: context.containerSize.width, height: 50)
        return ASSizeRange(min: size, max: size)
    }
    
    func didSelect(index: Int) {
        self.didSelect()
    }
}
