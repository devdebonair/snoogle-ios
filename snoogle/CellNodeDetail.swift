//
//  CellNodeDetail.swift
//  snoogle
//
//  Created by Vincent Moore on 12/26/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class CellNodeDetail: ASCellNode {
    let textMeta: ASTextNode
    let textTitle: ASTextNode
    let textSubtitle: ASTextNode
    let separator: ASDisplayNode
    
    let buttonDiscussion: ASButtonNode
    let buttonSave: ASButtonNode
    let buttonUpVote: ASButtonNode
    let buttonDownVote: ASButtonNode
    
    init(meta: NSAttributedString?, title: NSAttributedString?, subtitle: NSAttributedString?, buttonAttributes: [String:Any?]) {
        textMeta = ASTextNode()
        textTitle = ASTextNode()
        textSubtitle = ASTextNode()
        separator = ASDisplayNode()
        buttonDiscussion = ASButtonNode()
        buttonSave = ASButtonNode()
        buttonUpVote = ASButtonNode()
        buttonDownVote = ASButtonNode()
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        textMeta.attributedText = meta
        textTitle.attributedText = title
        textSubtitle.attributedText = subtitle
        
        textSubtitle.maximumNumberOfLines = 3
        
        buttonUpVote.setAttributedTitle(NSAttributedString(string: "Upvote", attributes: buttonAttributes), for: [])
        buttonDiscussion.setAttributedTitle(NSAttributedString(string: "Save", attributes: buttonAttributes), for: [])
        buttonDownVote.setAttributedTitle(NSAttributedString(string: "Downvote", attributes: buttonAttributes), for: [])
        buttonSave.setAttributedTitle(NSAttributedString(string: "View Discussion", attributes: buttonAttributes), for: [])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        separator.style.width = ASDimension(unit: .fraction, value: 1.0)
        separator.style.height = ASDimension(unit: .points, value: 1.0)
        separator.backgroundColor = UIColor(colorLiteralRed: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        
//        let stackLayoutButton = ASStackLayoutSpec(
//            direction: .horizontal,
//            spacing: 10.0,
//            justifyContent: .end,
//            alignItems: .center,
//            children: [
//                buttonSave,
//                buttonDownVote,
//                buttonUpVote
//            ])
//        
//        let stackLayoutButtonContainer = ASStackLayoutSpec(
//            direction: .horizontal,
//            spacing: 0.0,
//            justifyContent: .start,
//            alignItems: .center,
//            children: [
//                buttonDiscussion,
//                stackLayoutButton
//            ])
        
        let stackLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5.0,
            justifyContent: .start,
            alignItems: .start,
            children: [
                textMeta,
                textTitle,
                textSubtitle
            ])
        
        let padding: CGFloat = 20.0
        let inset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        return ASInsetLayoutSpec(insets: inset, child: stackLayout)
    }
}
