//
//  SubmissionSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 3/26/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class SubmissionSectionController: SectionController {
    
    var post: PostViewModel!
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
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
        let post = self.post!
        return { _ -> ASCellNode in
            return post.cell()
        }
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func didUpdate(to object: Any) {
        if let object = object as? PostViewModel {
            post = object
        }
    }
    
    override func didSelectItem(at index: Int) {
        print("selected photo: \(post.primaryKey())")
    }
    
}
