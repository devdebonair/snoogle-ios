//
//  CellNodeButtonBar.swift
//  snoogle
//
//  Created by Vincent Moore on 1/9/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeButtonBar: ASCellNode {
    let buttonDiscussion: ASButtonNode
    let buttonSave: ASButtonNode
    let buttonUpVote: ASButtonNode
    let buttonDownVote: ASButtonNode
    
    let COLOR_DISABLED = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
    let ATTRIBUTES_BUTTON = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium),
        NSForegroundColorAttributeName: UIColor(colorLiteralRed: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
    ]
    
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
        buttonDiscussion.setImage(#imageLiteral(resourceName: "talk"), for: [])
        
        buttonDiscussion.setAttributedTitle(NSAttributedString(string: leftButtonText, attributes: ATTRIBUTES_BUTTON), for: [])
        
        buttonSave.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(COLOR_DISABLED)
        buttonUpVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(COLOR_DISABLED)
        buttonDownVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(COLOR_DISABLED)
        
        buttonSave.contentMode = .scaleAspectFit
        buttonUpVote.contentMode = .scaleAspectFit
        buttonDownVote.contentMode = .scaleAspectFit
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stackLayoutButton = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 30.0,
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
        
        return insetButtonLayout
    }
}
