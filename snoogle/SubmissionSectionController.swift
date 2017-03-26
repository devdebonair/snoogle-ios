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
        let max = CGSize(width: width, height: CGFloat(FLT_MAX))
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let post = self.post!
        return { _ -> ASCellNode in
            let paragraphStyleMeta = NSMutableParagraphStyle()
            paragraphStyleMeta.lineSpacing = 2.0
            let meta = NSMutableAttributedString(
                string: post.meta,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 10),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0),
                    NSParagraphStyleAttributeName: paragraphStyleMeta
                ])
            
            let paragraphStyleTitle = NSMutableParagraphStyle()
            paragraphStyleTitle.lineSpacing = 4.0
            
            let title = NSMutableAttributedString(
                string: post.title,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                    NSForegroundColorAttributeName: UIColor.black,
                    NSParagraphStyleAttributeName: paragraphStyleTitle
                ])
            
            let paragraphStyleDescription = NSMutableParagraphStyle()
            paragraphStyleDescription.lineSpacing = 4.0
            
            let description = NSMutableAttributedString(
                string: post.info,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 13),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0),
                    NSParagraphStyleAttributeName: paragraphStyleDescription
                ])
            
            let leftButtonAttribute = NSMutableAttributedString(
                string: "\(post.numberOfComments) Comments",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
                ])
            
            return CellNodePost(meta: meta, title: title, subtitle: description, leftbuttonAttributes: leftButtonAttribute, media: post.media)
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
