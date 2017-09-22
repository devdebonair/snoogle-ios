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
    enum CellType: Int {
        case meta = 0
        case media = 1
        case title = 2
        case content = 3
    }
    
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
        if !media.isEmpty {
            retval.append(media)
        }
        retval.append(title)
        for paragraph in newContent {
            retval.append(paragraph)
        }
        return retval
    }
    
    private lazy var cellOrder: [CellType] = {
        var retval = [CellType]()
        if !self.media.isEmpty {
            retval.append(.media)
        }
        retval.append(.meta)
        retval.append(.title)
        for paragraph in self.newContent {
            retval.append(.content)
        }
        return retval
    }()
    
    func cell(index: Int) -> ASCellNode {
        let cellType = cellOrder[index]
        let padding: CGFloat = 20
        
        switch cellType {
        case .meta:
            let paragraphStyleMeta = NSMutableParagraphStyle()
            paragraphStyleMeta.lineSpacing = 2.0
            let metaAttributes = NSMutableAttributedString(
                string: self.meta,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 10),
                    NSParagraphStyleAttributeName: paragraphStyleMeta,
                    NSForegroundColorAttributeName: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
                ])
            let inset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
            
            let range = (meta as NSString).range(of: author)
            metaAttributes.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: range)
            metaAttributes.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: range)
            
            let cell = CellNodeText(attributedText: metaAttributes)
            cell.inset = inset
            return cell
        case .media:
            let cell = CellNodeMediaAlbum(media: self.media)
            return cell
        case .title:
                    let titleFont = UIFont(name: "Charter-Bold", size: 22)!
                    let titleColor = UIColor.darkText
//            let titleFont: UIFont = UIFont.systemFont(ofSize: 22, weight: UIFontWeightBlack)
            let inset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
            
            let paragraphStyleTitle = NSMutableParagraphStyle()
            paragraphStyleTitle.lineSpacing = 0.0
            
            let titleAttributes = NSMutableAttributedString(
                string: self.title,
                attributes: [
                    NSFontAttributeName: titleFont,
                    NSForegroundColorAttributeName: titleColor,
                    NSParagraphStyleAttributeName: paragraphStyleTitle
                ])
            
            let cell = CellNodeText(attributedText: titleAttributes)
            cell.inset = inset
            if index == numberOfCells() - 1 { cell.inset.bottom = padding }
            return cell
        case .content:
            let subArr = Array(cellOrder[0...index])
            let filterdArr = subArr.filter { $0 == .content }
            let paragraph = newContent[filterdArr.count-1]
            
            var inset = UIEdgeInsets(top: padding, left: 16, bottom: 0, right: 16)
            if index == numberOfCells() - 1 { inset.bottom = padding }
            let cell = CellNodeText(attributedText: paragraph)
            cell.inset = inset
            cell.textNode.delegate = self
            cell.textNode.isUserInteractionEnabled = true
            return cell
        }
    }
    
    func numberOfCells() -> Int {
        return cellOrder.count
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
