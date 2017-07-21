//
//  CellNodeMediaPageActionBar.swift
//  snoogle
//
//  Created by Vincent Moore on 7/20/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeMediaPageActionBar: ASCellNode {
    
    let progressIndicator = UIProgressView()
    lazy var progressNode: ASDisplayNode = {
        return ASDisplayNode(viewBlock: { () -> UIView in
            return self.progressIndicator
        })
    }()
    
    let buttonComment = ASButtonNode()
    let buttonSave = ASButtonNode()
    let buttonUpvote = ASButtonNode()
    let buttonDownvote = ASButtonNode()
    
    override init() {
        super.init()
        
        let font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        let color = UIColor.white
        
        let commentString = NSMutableAttributedString(
            string: "Comments",
            attributes: [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color
            ])
        
        let upString = NSMutableAttributedString(
            string: "Upvote",
            attributes: [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color
            ])
        
        let downString = NSMutableAttributedString(
            string: "Downvote",
            attributes: [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color
            ])
        
        let saveString = NSMutableAttributedString(
            string: "Save",
            attributes: [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color
            ])
        
        let contentSpacing: CGFloat = 2.0
        buttonSave.contentSpacing = contentSpacing
        buttonComment.contentSpacing = contentSpacing
        buttonUpvote.contentSpacing = contentSpacing
        buttonDownvote.contentSpacing = contentSpacing
        
        buttonSave.setImage(#imageLiteral(resourceName: "star-filled"), for: [])
        buttonComment.setImage(#imageLiteral(resourceName: "chat-filled"), for: [])
        buttonUpvote.setImage(#imageLiteral(resourceName: "up-arrow-filled"), for: [])
        buttonDownvote.setImage(#imageLiteral(resourceName: "down-arrow-filled"), for: [])
        
        buttonSave.imageNode.contentMode = .scaleAspectFit
        buttonComment.imageNode.contentMode = .scaleAspectFit
        buttonUpvote.imageNode.contentMode = .scaleAspectFit
        buttonDownvote.imageNode.contentMode = .scaleAspectFit
        
        buttonSave.setAttributedTitle(saveString, for: [])
        buttonComment.setAttributedTitle(commentString, for: [])
        buttonUpvote.setAttributedTitle(upString, for: [])
        buttonDownvote.setAttributedTitle(downString, for: [])
        
        buttonUpvote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
        buttonDownvote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
        buttonComment.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
        buttonSave.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
        
        progressIndicator.trackTintColor = .darkGray
        progressIndicator.progressTintColor = .white
        
        automaticallyManagesSubnodes = true
    }
    
    func setProgress(_ amount: Float, animated: Bool = false) {
        self.progressIndicator.setProgress(amount, animated: animated)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let buttonSize: CGFloat = 14
        buttonSave.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonUpvote.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonDownvote.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonComment.style.height = ASDimension(unit: .points, value: buttonSize)
        
        progressNode.style.height = ASDimension(unit: .points, value: 0.0)
        progressNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        
        let stack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 25,
            justifyContent: .center,
            alignItems: .center,
            children: [
                buttonComment,
                buttonDownvote,
                buttonUpvote,
                buttonSave
            ])
        
        let insetButtonsValue = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        let insetButtons = ASInsetLayoutSpec(insets: insetButtonsValue, child: stack)
        
        let stackContainer = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0.0,
            justifyContent: .center,
            alignItems: .start,
            children: [
                progressNode,
                insetButtons
            ])
        
        stack.style.flexGrow = 1.0
        
        let inset = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
        
        return ASInsetLayoutSpec(insets: inset, child: stackContainer)
    }
}
