//
//  SubredditAboutViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/4/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SubredditAboutViewModel: NSObject, ViewModelElement {
    enum CellType: Int {
        case header = 0
        case text = 1
    }
    
    let text: String
    let cellOrder: [CellType] = [.header, .text]
    
    init(subreddit: Subreddit) {
        self.text = subreddit.publicDescriptionStripped
        super.init()
    }
    
    func numberOfCells() -> Int {
        return cellOrder.count
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellOrder[index]
        switch type {
        case .header:
            let header = NSMutableAttributedString(
                string: "ABOUT",
                attributes: [
                    NSKernAttributeName: CGFloat(1.3),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightHeavy),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 45/255, green: 46/255, blue: 48/255, alpha: 1.0)
                ])
            let cell = CellNodeText(attributedText: header)
            cell.inset = UIEdgeInsets(top: 0, left: 25, bottom: 5, right: 25)
            return cell
        case .text:
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 2.0
            let text = NSMutableAttributedString(
                string: self.text,
                attributes: [
                    NSParagraphStyleAttributeName: style,
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 45/255, green: 46/255, blue: 48/255, alpha: 1.0)
                ])
            let cell = CellNodeText(attributedText: text)
            cell.inset = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 25)
            cell.hasSeparator = true
            cell.separatorColor = UIColor(colorLiteralRed: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
            cell.separatorThickness = 2.0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
            return cell
        }
    }
}
