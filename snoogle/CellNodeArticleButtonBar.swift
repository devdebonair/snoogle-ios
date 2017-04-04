//
//  CellNodeButtonBar.swift
//  snoogle
//
//  Created by Vincent Moore on 1/4/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CellNodeArticleButtonBar: ASCellNode {
    
    let buttonDiscussion: ASButtonNode
    let buttonSave: ASButtonNode
    let buttonUpVote: ASButtonNode
    let buttonDownVote: ASButtonNode
    
    let separatorTop = ASDisplayNode()
    let separatorBottom = ASDisplayNode()
    
    let COLOR_DISABLED = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
    
    init(leftButtonText: String) {
        buttonDiscussion = ASButtonNode()
        buttonSave = ASButtonNode()
        buttonUpVote = ASButtonNode()
        buttonDownVote = ASButtonNode()
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        buttonSave.setImage(#imageLiteral(resourceName: "star"), for: [])
        buttonUpVote.setImage(#imageLiteral(resourceName: "up-arrow"), for: [])
        buttonDownVote.setImage(#imageLiteral(resourceName: "down-arrow"), for: [])
        buttonDiscussion.setImage(#imageLiteral(resourceName: "chat"), for: [])
        
        let commentFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        let commentColor = UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
        let commentAttributes = [
            NSFontAttributeName: commentFont,
            NSForegroundColorAttributeName: commentColor
        ]
        
        buttonDiscussion.setAttributedTitle(NSAttributedString(string: leftButtonText, attributes: commentAttributes), for: [])
        
        buttonSave.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
        buttonUpVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
        buttonDownVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
        
        buttonSave.imageNode.contentMode = .scaleAspectFit
        buttonUpVote.imageNode.contentMode = .scaleAspectFit
        buttonDownVote.imageNode.contentMode = .scaleAspectFit
        buttonDiscussion.imageNode.contentMode = .scaleAspectFit
        
        separatorTop.backgroundColor = COLOR_DISABLED
        separatorBottom.backgroundColor = COLOR_DISABLED
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonSize: CGFloat = 16
        buttonSave.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonUpVote.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonDownVote.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonDiscussion.style.height = ASDimension(unit: .points, value: buttonSize)
        
        let stackLayoutButton = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 15.0,
            justifyContent: .end,
            alignItems: .center,
            children: [
                buttonSave,
                buttonDownVote,
                buttonUpVote
            ])
        
        let stackLayoutButtonContainer = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0.0,
            justifyContent: .start,
            alignItems: .center,
            children: [
                buttonDiscussion,
                stackLayoutButton
            ])
        
        stackLayoutButton.style.flexGrow = 1.0
        stackLayoutButtonContainer.style.width = ASDimension(unit: .points, value: constrainedSize.max.width)
        
        let buttonInset = UIEdgeInsets(top: 15, left: 20.0, bottom: 15, right: 20.0)
        let insetButtonLayout = ASInsetLayoutSpec(insets: buttonInset, child: stackLayoutButtonContainer)
        
        separatorTop.style.width = ASDimension(unit: .fraction, value: 1.0)
        separatorTop.style.height = ASDimension(unit: .points, value: 1.0)
        
        separatorBottom.style.width = ASDimension(unit: .fraction, value: 1.0)
        separatorBottom.style.height = ASDimension(unit: .points, value: 1.0)
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical, spacing: 0.0, justifyContent: .start, alignItems: .start, children: [separatorTop, insetButtonLayout, separatorBottom])
        
        return stackLayout
    }
}
