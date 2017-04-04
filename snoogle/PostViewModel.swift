//
//  Post.swift
//  snoogle
//
//  Created by Vincent Moore on 1/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

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
    
    init(id: String, meta: String = "", title: String = "", info: String = "", media: [MediaElement] = [], numberOfComments: Int = 0, inSub: Bool = false, isSticky: Bool = false, vote: VoteType = .none, saved: Bool = false) {
        self.id = id
        self.meta = meta
        self.title = title
        self.info = info
        self.media = media
        self.numberOfComments = numberOfComments
        self.isSticky = isSticky
        self.vote = vote
        self.saved = saved
    }
    
    override func primaryKey() -> NSObjectProtocol {
        return NSString(string: id)
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func didUpvote() {
        ServiceSubmission(id: id).upvote()
    }
    
    func didDownvote() {
        ServiceSubmission(id: id).downvote()
    }
    
    func didSave() {
        ServiceSubmission(id: id).save()
    }
    
    func didUnsave() {
        ServiceSubmission(id: id).unsave()
    }
    
    func didUnvote() {
        ServiceSubmission(id: id).unvote()
    }
    
    func cell(index: Int) -> ASCellNode {
        let stickyColor = UIColor(colorLiteralRed: 38/255, green: 166/255, blue: 91/255, alpha: 1.0)
        let stickyFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightHeavy)
        
        let titleFont = UIFont.systemFont(ofSize: 15)
        let titleLineSpacing: CGFloat = 4.0
        
        let metaFont = UIFont.systemFont(ofSize: 10)
        let metaColor = UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        let metaLineSpacing: CGFloat = 2.0
        
        let descriptionFont = UIFont.systemFont(ofSize: 13)
        let descriptionColor = UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        let descriptionLineSpacing: CGFloat = 4.0
        
        let commentFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        let commentColor = UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
        
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
        
        let leftButtonAttribute = NSMutableAttributedString(
            string: "\(self.numberOfComments) Comments",
            attributes: [
                NSFontAttributeName: commentFont,
                NSForegroundColorAttributeName: commentColor
            ])
        
        let post = CellNodePost(
            meta: meta,
            title: title,
            subtitle: description,
            leftbuttonAttributes:
            leftButtonAttribute,
            media: self.media,
            vote: vote,
            saved: saved)
        
        post.delegate = self
        
        return post
    }
}
