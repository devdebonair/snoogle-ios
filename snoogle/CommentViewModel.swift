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
        let fontSizeBody: CGFloat = 12
        
        let metaAttribute = NSMutableAttributedString(
            string: comment.meta,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeMeta),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
            ])
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 4.0
        
        let bodyAttribute = NSMutableAttributedString(
            string: comment.body,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeBody),
                NSForegroundColorAttributeName: UIColor.black,
                NSParagraphStyleAttributeName: paragraph
            ])
        
        let margin: CGFloat = 20
        let inset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        let cell  = CellNodeComment(meta: metaAttribute, body: bodyAttribute, inset: inset, numberOfGutters: comment.level, gutterColor: .lightGray)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfCells() -> Int {
        return comments.count
    }
    
}
