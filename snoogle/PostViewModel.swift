//
//  Post.swift
//  snoogle
//
//  Created by Vincent Moore on 1/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol PostViewModelDelegate {
    func didSelectPost(post: PostViewModel)
    func didTapLink(post: PostViewModel)
    func didUpvote(post: PostViewModel)
    func didDownvote(post: PostViewModel)
    func didSave(post: PostViewModel)
    func didUnsave(post: PostViewModel)
    func didUnvote(post: PostViewModel)
    func didTapComments(post: PostViewModel)
    func didTapMedia(post: PostViewModel, index: Int)
}

class PostViewModel: NSObject, ViewModelElement, CellNodePostDelegate {
    let meta: String
    let title: String
    let info: String
    let media: [MediaElement]
    let numberOfComments: Int
    let id: String
    let isSticky: Bool
    let vote: VoteType
    let saved: Bool
    let hint: PostHintType?
    let domain: String
    
    var delegate: PostViewModelDelegate? = nil
    
    init(id: String, meta: String = "", title: String = "", info: String = "", media: [MediaElement] = [], numberOfComments: Int = 0, inSub: Bool = false, isSticky: Bool = false, vote: VoteType = .none, saved: Bool = false, hint: PostHintType? = nil, domain: String = "") {
        self.id = id
        self.meta = meta
        self.title = title
        self.info = info
        self.media = media
        self.numberOfComments = numberOfComments
        self.isSticky = isSticky
        self.vote = vote
        self.saved = saved
        self.hint = hint
        self.domain = domain
    }
    
    override func primaryKey() -> NSObjectProtocol {
        return NSString(string: id)
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func didUpvote() {
        guard let delegate = delegate else { return }
        delegate.didUpvote(post: self)
    }
    
    func didDownvote() {
        guard let delegate = delegate else { return }
        delegate.didDownvote(post: self)
    }
    
    func didSave() {
        guard let delegate = delegate else { return }
        delegate.didSave(post: self)
    }
    
    func didUnsave() {
        guard let delegate = delegate else { return }
        delegate.didUnsave(post: self)
    }
    
    func didUnvote() {
        guard let delegate = delegate else { return }
        delegate.didUnvote(post: self)
    }
    
    func didTapLink() {
        guard let delegate = delegate else { return }
        delegate.didTapLink(post: self)
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        delegate.didSelectPost(post: self)
    }
    
    func didTapComments() {
        guard let delegate = delegate else { return }
        delegate.didTapComments(post: self)
    }
    
    func didTapMedia(index: Int) {
        guard let delegate = delegate else { return }
        delegate.didTapMedia(post: self, index: index)
    }
    
    func cell(index: Int) -> ASCellNode {
        let stickyColor = UIColor(colorLiteralRed: 38/255, green: 166/255, blue: 91/255, alpha: 1.0)
        let stickyFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightHeavy)
        
        let titleFont = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        let titleLineSpacing: CGFloat = 4.0
        
        let metaFont = UIFont.systemFont(ofSize: 10)
        let metaColor = UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        let metaLineSpacing: CGFloat = 2.0
        
        let descriptionFont = UIFont.systemFont(ofSize: 13)
        let descriptionColor = UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        let descriptionLineSpacing: CGFloat = 4.0
        
        let linkTitleFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        let linkTitleColor = UIColor.darkText
        let linkTitleLineSpacing: CGFloat = 2.0
        
        let linkSubtitleFont = UIFont.systemFont(ofSize: 13)
        let linkSubtitleColor = UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        let linkSubtitleLineSpacing: CGFloat = 2.0
        
        let paragraphStyleMeta = NSMutableParagraphStyle()
        paragraphStyleMeta.lineSpacing = metaLineSpacing
        let meta = NSMutableAttributedString(
            string: self.meta,
            attributes: [
                NSFontAttributeName: metaFont,
                NSForegroundColorAttributeName: metaColor,
                NSParagraphStyleAttributeName: paragraphStyleMeta
            ])
        
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.lineSpacing = titleLineSpacing
        
        let title = NSMutableAttributedString(
            string: self.title,
            attributes: [
                NSFontAttributeName: (isSticky ? stickyFont : titleFont),
                NSForegroundColorAttributeName: (isSticky ? stickyColor : UIColor.black),
                NSParagraphStyleAttributeName: paragraphStyleTitle
            ])
        
        let paragraphStyleDescription = NSMutableParagraphStyle()
        paragraphStyleDescription.lineSpacing = descriptionLineSpacing
        
        let description = NSMutableAttributedString(
            string: self.info,
            attributes: [
                NSFontAttributeName: descriptionFont,
                NSForegroundColorAttributeName: descriptionColor,
                NSParagraphStyleAttributeName: paragraphStyleDescription
            ])
        
        
        
        if let hint = hint, hint == .link {
            let paragraphStyleLinkTitle = NSMutableParagraphStyle()
            paragraphStyleLinkTitle.lineSpacing = linkTitleLineSpacing
            
            let paragraphStyleLinkSubtitle = NSMutableParagraphStyle()
            paragraphStyleLinkSubtitle.lineSpacing = linkSubtitleLineSpacing
            
            let linkTitle = NSMutableAttributedString(
                string: self.title,
                attributes: [
                    NSFontAttributeName: linkTitleFont,
                    NSForegroundColorAttributeName: linkTitleColor,
                    NSParagraphStyleAttributeName: paragraphStyleLinkTitle
                ])
            
            let linkSubtitle = NSMutableAttributedString(
                string: domain,
                attributes: [
                    NSFontAttributeName: linkSubtitleFont,
                    NSForegroundColorAttributeName: linkSubtitleColor,
                    NSParagraphStyleAttributeName: paragraphStyleLinkSubtitle
                ])
            
            let cell = CellNodePostLink(
                meta: meta,
                title: title,
                subtitle: description,
                media: self.media.first,
                vote: vote,
                saved: saved,
                linkTitle: linkTitle,
                linkSubtitle: linkSubtitle)
            
            cell.delegate = self
            
            return cell
        }
        
        let post = CellNodePost(
            meta: meta,
            title: title,
            subtitle: description,
            media: self.media,
            vote: vote,
            saved: saved,
            numberOfComments: numberOfComments)
        
        post.delegate = self
        
        return post
    }
}
