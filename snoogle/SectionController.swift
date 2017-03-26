//
//  SectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 3/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class SectionController: IGListSectionController, ASSectionController {
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        return ASSizeRangeZero
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return { _ -> ASCellNode in
            return ASCellNode()
        }
    }
    
    override func numberOfItems() -> Int {
        return 0
    }
    
    func beginBatchFetch(with context: ASBatchContext) {
        if let controller = viewController as? CollectionController, controller.shouldFetch() {
            controller.fetch(context: context)
        }
    }
    
    override func didUpdate(to object: Any) {}
    override func didSelectItem(at index: Int) {}
}
