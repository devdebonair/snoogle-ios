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

class ArticleViewModel: NSObject, ViewModelElement {
    let author: String
    let origin: String
    let created: Date
    
    let title: String
    let media: [MediaElement]
    let content: [String]
    
    let numberOfComments: Int
    
    var meta: String {
        return "\(author)\nposted on \(origin)\n\(created.timeAgo(shortened: false))"
    }
    
    init(author: String = "", origin: String = "", created: Date, title: String = "", media: [MediaElement] = [], content: [String] = [], vote: VoteType, saved: Bool, numberOfComments: Int = 0) {
        self.author = author
        self.origin = origin
        self.created = created
        self.title = title
        self.media = media
        self.content = content
        self.numberOfComments = numberOfComments
    }
    
    // button, title, meta, separator
    private let numberOfRequiredCells = 4
    
    private var elements: [Any] {
        var retval = [Any]()
        retval.append(meta)
        retval.append(title)
        if !media.isEmpty {
            retval.append(media)
        }
        for paragraph in content {
            retval.append(paragraph)
        }
        return retval
    }
    
    func cell(index: Int) -> ASCellNode {
        
        let row = index
        let element = elements[row]
        
        // Meta
        if let element = element as? String, row == 0 {
            let paragraphStyleMeta = NSMutableParagraphStyle()
            paragraphStyleMeta.lineSpacing = 2.0
            let metaAttributes = NSMutableAttributedString(
                string: element,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 10),
                    NSParagraphStyleAttributeName: paragraphStyleMeta,
                    NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                ])
            let inset = UIEdgeInsets(top: 40, left: 20, bottom: 10, right: 20)
            
            let range = (meta as NSString).range(of: author)
            metaAttributes.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: range)
            metaAttributes.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: range)
            
            return CellNodeText(attributedText: metaAttributes, inset: inset)
        }
        
        // Title
        if let element = element as? String, row == 1 {
            let inset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            
            let paragraphStyleTitle = NSMutableParagraphStyle()
            paragraphStyleTitle.lineSpacing = 4.0
            
            let titleAttributes = NSMutableAttributedString(
                string: element,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBlack),
                    NSForegroundColorAttributeName: UIColor.black,
                    NSParagraphStyleAttributeName: paragraphStyleTitle
                ])
            
            return CellNodeText(attributedText: titleAttributes, inset: inset)
        }
        
        // Media
        if let element = element as? [MediaElement] {
            let inset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            return CellNodeMedia(media: element, inset: inset)
        }
        
        
        // Content
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
    
    func footer() -> ASCellNode? {
        let cell = CellNodeArticleButtonBar()
        cell.backgroundColor = .white
        return cell
    }
    
    func footerSize() -> ASSizeRange {
        return ASSizeRangeUnconstrained
    }
}
