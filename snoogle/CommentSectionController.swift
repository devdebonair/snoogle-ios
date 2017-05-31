//
//  CommentSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 5/16/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class CommentSectionController: SectionController {
    
    var comment: CommentViewModel! {
        return model as! CommentViewModel
    }
    
    override func sizeRangeForItem(at index: Int) -> ASSizeRange {
        guard let context = collectionContext else {
            return ASSizeRangeUnconstrained
        }
        let width: CGFloat = context.containerSize.width - self.inset.left - self.inset.right
        let max = CGSize(width: width, height: context.containerSize.height)
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
}
