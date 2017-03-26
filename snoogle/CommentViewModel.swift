////
////  CommentViewModel.swift
////  snoogle
////
////  Created by Vincent Moore on 1/8/17.
////  Copyright © 2017 Vincent Moore. All rights reserved.
////
//
//import Foundation
//import AsyncDisplayKit
//
//struct CommentViewModel: ViewModelElement {
//
//    let meta: String
//    let body: String
//    let level: Int
//    
//    func cellAtRow(indexPath: IndexPath) -> ASCellNode {
//        let fontSizeMeta: CGFloat = 12
//        let fontSizeBody: CGFloat = 14
//        
//        let metaAttribute = NSMutableAttributedString(
//            string: meta,
//            attributes: [
//                NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeMeta),
//                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
//            ])
//        
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineSpacing = 4.0
//        
//        let bodyAttribute = NSMutableAttributedString(
//            string: body,
//            attributes: [
//                NSFontAttributeName: UIFont.systemFont(ofSize: fontSizeBody),
//                NSForegroundColorAttributeName: UIColor.black,
//                NSParagraphStyleAttributeName: paragraph
//            ])
//        
//        let leftMargin: CGFloat = 20 + CGFloat(level * 20)
//        let inset = UIEdgeInsets(top: 20, left: leftMargin, bottom: 20, right: 20)
//        
//        let cell = CellNodeComment(meta: metaAttribute, body: bodyAttribute, inset: inset)
//        cell.backgroundColor = .white
//        cell.selectionStyle = .none
//        return cell
//    }
//    
//    func numberOfCells() -> Int {
//        return 1
//    }
//    
//}
