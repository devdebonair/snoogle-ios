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
    
    let INSET: CGFloat = 5
    
    var post: PostViewModel {
        return model as! PostViewModel
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: INSET, left: 0, bottom: INSET, right: 0)
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
        let post = self.post
        return { _ -> ASCellNode in
            return post.cell(index: index)
        }
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func didUpdate(to object: Any) {
        if let object = object as? PostViewModel {
            model = object
        }
    }
    
    override func didSelectItem(at index: Int) {
        if let viewController = self.viewController {
            let controller = ArticleCollectionController(id: post.id)
            viewController.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
}
