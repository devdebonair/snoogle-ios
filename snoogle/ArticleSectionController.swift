//
//  ArticleSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 4/1/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class ArticleSectionController: SectionController {
    
    var article: ArticleViewModel! {
        return model as! ArticleViewModel
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
        let article = self.article!
        return { _ -> ASCellNode in
            return article.cell(index: index)
        }
    }
    
    override func numberOfItems() -> Int {
        return article.numberOfCells()
    }
    
    override func didUpdate(to object: Any) {
        if let object = object as? ArticleViewModel {
            model = object
        }
    }
    
    override func didSelectItem(at index: Int) {
        print("selected photo: \(article.primaryKey())")
    }
}
