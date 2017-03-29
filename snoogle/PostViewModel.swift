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
    
    init(id: String, meta: String = "", title: String = "", info: String = "", media: [MediaElement] = [], numberOfComments: Int = 0, inSub: Bool = false, isSticky: Bool = false) {
        self.id = id
        self.meta = meta
        self.title = title
        self.info = info
        self.media = media
        self.numberOfComments = numberOfComments
        self.isSticky = isSticky
    }
    
    override func primaryKey() -> NSObjectProtocol {
        return NSString(string: id)
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func didUpvote() {
        print("an upvote should happen here")
    }
    
    func didDownvote() {
        print("a downvote should happen here")
    }
    
    func didSave() {
        print("a save should happen here")
    }
    
    func didUnsave() {
        print("an unsave should happen here")
    }
    
    func didUnvote() {
        print("an unvote should happen here")
    }
    
    func cell() -> ASCellNode {
        
        let stickyColor = UIColor(colorLiteralRed: 38/255, green: 166/255, blue: 91/255, alpha: 1.0)
        let stickyFont = UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        
        let paragraphStyleMeta = NSMutableParagraphStyle()
        paragraphStyleMeta.lineSpacing = 2.0
        let meta = NSMutableAttributedString(
            string: self.meta,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 10),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0),
                NSParagraphStyleAttributeName: paragraphStyleMeta
            ])
        
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.lineSpacing = 4.0
        
        let title = NSMutableAttributedString(
            string: self.title,
            attributes: [
                NSFontAttributeName: (isSticky ? stickyFont : UIFont.systemFont(ofSize: 17)),
                NSForegroundColorAttributeName: (isSticky ? stickyColor : UIColor.black),
                NSParagraphStyleAttributeName: paragraphStyleTitle
            ])
        
        let paragraphStyleDescription = NSMutableParagraphStyle()
        paragraphStyleDescription.lineSpacing = 4.0
        
        let description = NSMutableAttributedString(
            string: self.info,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 13),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0),
                NSParagraphStyleAttributeName: paragraphStyleDescription
            ])
        
        let leftButtonAttribute = NSMutableAttributedString(
            string: "\(self.numberOfComments) Comments",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular),
                NSForegroundColorAttributeName: UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
            ])
        
        let post = CellNodePost(
            meta: meta,
            title: title,
            subtitle: description,
            leftbuttonAttributes:
            leftButtonAttribute,
            media: self.media)
        
        post.delegate = self
        
        return post
    }
}
