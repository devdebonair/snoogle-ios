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
        let fontSizeBody: CGFloat = 14
        let fontColor = ThemeManager.textPrimary()
        
        let metaAttribute = NSMutableAttributedString(
            string: comment.meta,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeMeta, weight: UIFontWeightBold),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()
            ])
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2.0
        
        let bodyAttribute = NSMutableAttributedString(
            string: comment.body,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeBody),
                NSForegroundColorAttributeName: fontColor,
                NSParagraphStyleAttributeName: paragraph
            ])
        
        let margin: CGFloat = 15
        let inset = UIEdgeInsets(top: 15.0, left: margin, bottom: 15.0, right: margin)
        let gutterColor = ThemeManager.textPrimary().withAlphaComponent(0.1)
        let cell = CellNodeComment(meta: metaAttribute, body: bodyAttribute, inset: inset, numberOfGutters: comment.level, gutterColor: gutterColor)
        cell.backgroundColor = ThemeManager.cellBackground()
        cell.selectionStyle = .none
        cell.backgroundNode.backgroundColor = ThemeManager.background()
        return cell
    }
    
    func numberOfCells() -> Int {
        return comments.count
    }
}
