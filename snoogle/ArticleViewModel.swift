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

protocol ArticleViewModelDelegate {
    func didTapLink(url: URL)
}

class ArticleViewModel: NSObject, ViewModelElement, ASTextNodeDelegate {
    let author: String
    let origin: String
    let created: Date
    let title: String
    let media: [MediaElement]
    let content: [String]
    let vote: VoteType
    let saved: Bool
    let numberOfComments: Int
    var newContent = [NSMutableAttributedString]()
    
    var delegate: ArticleViewModelDelegate? = nil
    
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
        self.vote = vote
        self.saved = saved
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
        for paragraph in newContent {
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
            let inset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
            
            let range = (meta as NSString).range(of: author)
            metaAttributes.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: range)
            metaAttributes.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: range)
            
            let cell = CellNodeText(attributedText: metaAttributes)
            cell.inset = inset
            return cell
        }
        
        // Title
        let titleFont: UIFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightHeavy)
        if let element = element as? String, row == 1 {
            let inset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            
            let paragraphStyleTitle = NSMutableParagraphStyle()
            paragraphStyleTitle.lineSpacing = 4.0
            
            let titleAttributes = NSMutableAttributedString(
                string: element,
                attributes: [
                    NSFontAttributeName: titleFont,
                    NSForegroundColorAttributeName: UIColor.darkText,
                    NSParagraphStyleAttributeName: paragraphStyleTitle
                ])
            
            let cell = CellNodeText(attributedText: titleAttributes)
            cell.inset = inset
            return cell
        }
        
        // Media
        if let media = element as? [MediaElement] {
            let cell = CellNodeMediaAlbum(media: media)
//            if media.count == 1 {
//                cell.collectionNode.view.bounces = false
//                cell.collectionNode.view.isScrollEnabled = false
//                cell.collectionNode.clipsToBounds = true
//            }
//            
//            if media.count > 1 {
//                cell.flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//                cell.flowLayout.minimumLineSpacing = 15.0
//            }
            return cell
        }
        
        // Content
        if let element = element as? NSMutableAttributedString {
            var inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
            if index == numberOfCells() - 1 { inset.bottom = 30 }
            let cell = CellNodeText(attributedText: element)
            cell.inset = inset
            cell.textNode.delegate = self
            cell.textNode.isUserInteractionEnabled = true
            return cell
        }
        
        return ASCellNode()
    }
    
    func numberOfCells() -> Int {
        return elements.count
    }
    
    func footer() -> ASCellNode? {
        let cell = CellNodeArticleButtonBar(vote: vote, saved: saved, numberOfComments: numberOfComments)
        cell.backgroundColor = .white
        return cell
    }
    
    func footerSize() -> ASSizeRange {
        return ASSizeRangeUnconstrained
    }
    
    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        guard let value = value as? URL, let delegate = delegate else { return }
        delegate.didTapLink(url: value)
    }
    
    func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
        return true
    }
}
