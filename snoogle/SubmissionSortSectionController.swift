//
//  SubmissionSortSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 5/29/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class SubmissionSortSectionController: SectionController {
    
    let INSET: CGFloat = 4
    
    var sortSelection: SubmissionSortViewModel {
        return model as! SubmissionSortViewModel
    }
    
    override init() {
        super.init()
    }
    
    override func sizeRangeForItem(at index: Int) -> ASSizeRange {
        guard let context = collectionContext else {
            return ASSizeRangeUnconstrained
        }
        let width: CGFloat = context.containerSize.width - self.inset.left - self.inset.right
        let max = CGSize(width: width, height: CGFloat(Float.greatestFiniteMagnitude))
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let sortSelection = self.sortSelection
        return { _ -> ASCellNode in
            return sortSelection.cell(index: index)
        }
    }
    
    override func numberOfItems() -> Int {
        return sortSelection.numberOfCells()
    }
    
    override func didUpdate(to object: Any) {
        if let object = object as? SubmissionSortViewModel {
            model = object
        }
    }
    
    override func didSelectItem(at index: Int) {
        print("selected an item")
    }
    
}
