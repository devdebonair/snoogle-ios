//
//  Article.swift
//  snoogle
//
//  Created by Vincent Moore on 1/4/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

struct ArticleViewModel: ViewModelElement {

    let meta: String
    let title: String
    let media: MediaElement?
    let content: [String]
    
    // button, title, meta, separator
    private let numberOfRequiredCells = 4
    
    private var elements: [Any] {
        var retval = [Any]()
        retval.append(meta)
        retval.append(title)
        if let media = media {
            retval.append(media)
        }
        for paragraph in content {
            retval.append(paragraph)
        }
        return retval
    }
    
    func cellAtRow(indexPath: IndexPath) -> ASCellNode {
        
        let row = indexPath.row
        let element = elements[row]
        
        if let element = element as? String, row == 0 {
            let metaAttributes = NSMutableAttributedString(
                string: element,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                ])
            let inset = UIEdgeInsets(top: 100, left: 20, bottom: 10, right: 20)
            return CellNodeText(attributedText: metaAttributes, inset: inset)
        }
        
        if let element = element as? String, row == 1 {
            
            let inset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            
            let paragraphStyleTitle = NSMutableParagraphStyle()
            paragraphStyleTitle.lineSpacing = 4.0
            
            let titleAttributes = NSMutableAttributedString(
                string: element,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 20),
                    NSForegroundColorAttributeName: UIColor.black,
                    NSParagraphStyleAttributeName: paragraphStyleTitle
                ])
            
            return CellNodeText(attributedText: titleAttributes, inset: inset)
        }
        
        if let element = element as? MediaElement {
            let inset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            return CellNodeMedia(media: element, inset: inset)
        }
        
        if let element = element as? String {
            let inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
            let paragraphStyleDescription = NSMutableParagraphStyle()
            paragraphStyleDescription.lineSpacing = 6.0
            let description = NSMutableAttributedString(
                string: element,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 15),
                    NSForegroundColorAttributeName: UIColor.black,
                    NSParagraphStyleAttributeName: paragraphStyleDescription
                ])
            
            return CellNodeText(attributedText: description, inset: inset)
        }
        
        return ASCellNode()
    }
    
    func numberOfCells() -> Int {
        return elements.count
    }
}
