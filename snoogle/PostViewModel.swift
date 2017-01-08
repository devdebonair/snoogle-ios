//
//  Post.swift
//  snoogle
//
//  Created by Vincent Moore on 1/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

struct PostViewModel: ViewModelElement {
    
    let meta: String
    let title: String
    let description: String
    let media: MediaElement?
    let numberOfComments: Int
    
    func cellAtRow(indexPath: IndexPath) -> ASCellNode {
        let paragraphStyleMeta = NSMutableParagraphStyle()
        paragraphStyleMeta.lineSpacing = 2.0
        let meta = NSMutableAttributedString(
            string: self.meta,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 10),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0),
                NSParagraphStyleAttributeName: paragraphStyleMeta
            ])
        
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.lineSpacing = 4.0
        
        let title = NSMutableAttributedString(
            string: self.title,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                NSForegroundColorAttributeName: UIColor.black,
                NSParagraphStyleAttributeName: paragraphStyleTitle
            ])
        
        let paragraphStyleDescription = NSMutableParagraphStyle()
        paragraphStyleDescription.lineSpacing = 4.0
        
        let description = NSMutableAttributedString(
            string: self.description,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0),
                NSParagraphStyleAttributeName: paragraphStyleDescription
            ])
        
        let leftButtonAttribute = NSMutableAttributedString(
            string: "\(numberOfComments) Comments",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
            ])
        
        return CellNodePost(meta: meta, title: title, subtitle: description, leftbuttonAttributes: leftButtonAttribute, media: media)
    }
    
    func numberOfCells() -> Int {
        return 1
    }
}
