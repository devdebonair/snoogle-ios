//
//  CommentViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 1/8/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CommentViewModel: NSObject, ViewModelElement {

    let comments: [StructComment]
    
    init(comments: [StructComment] = [StructComment]()) {
        self.comments = comments
    }
    
    func cell(index: Int) -> ASCellNode {
        let comment = comments[index]
        let fontSizeMeta: CGFloat = 10
        let fontSizeBody: CGFloat = 13
        
        let metaAttribute = NSMutableAttributedString(
            string: comment.meta,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeMeta, weight: UIFontWeightBold),
                NSForegroundColorAttributeName: UIColor.darkText
            ])
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2.0
        
        let bodyAttribute = NSMutableAttributedString(
            string: comment.body,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeBody),
                NSForegroundColorAttributeName: UIColor.darkText,
                NSParagraphStyleAttributeName: paragraph
            ])
        
        let margin: CGFloat = 15
        let inset = UIEdgeInsets(top: 15.0, left: margin, bottom: 15.0, right: margin)
        let gutterColorValue: Float = 235/255
        let gutterColor = UIColor(colorLiteralRed: gutterColorValue, green: gutterColorValue, blue: gutterColorValue, alpha: 1.0)
        let cell = CellNodeComment(meta: metaAttribute, body: bodyAttribute, inset: inset, numberOfGutters: comment.level, gutterColor: gutterColor)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfCells() -> Int {
        return comments.count
    }
}
