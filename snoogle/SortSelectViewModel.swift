////
////  SortSelect.swift
////  snoogle
////
////  Created by Vincent Moore on 1/13/17.
////  Copyright © 2017 Vincent Moore. All rights reserved.
////
//
//import Foundation
//import AsyncDisplayKit
//
//struct SortSelectViewModel: ViewModelElement {
//    
//    let title: String
//    
//    func cellAtRow(indexPath: IndexPath) -> ASCellNode {
//        let attributes = NSMutableAttributedString(
//            string: title,
//            attributes: [
//                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
//                NSForegroundColorAttributeName: UIColor.lightGray
//            ])
//        let cell = CellNodeText(attributedText: attributes)
//        return cell
//    }
//    
//    func numberOfCells() -> Int {
//        return 1
//    }
//}
