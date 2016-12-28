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
        
        buttonSave.setAttributedTitle(NSAttributedString(string: "Save", attributes: buttonAttributes), for: [])
        buttonUpVote.setAttributedTitle(NSAttributedString(string: "Upvote", attributes: buttonAttributes), for: [])
        buttonDownVote.setAttributedTitle(NSAttributedString(string: "Downvote", attributes: buttonAttributes), for: [])
        buttonDiscussion.setAttributedTitle(NSAttributedString(string: "View Discussion", attributes: buttonAttributes), for: [])
        
        separator.backgroundColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        separator.style.width = ASDimension(unit: .fraction, value: 1.0)
        separator.style.height = ASDimension(unit: .points, value: 1.0)
        
        buttonDiscussion.style.flexGrow = 1.0
        
        var contentLayoutElements = [ASLayoutElement]()
        contentLayoutElements.append(textMeta)
        contentLayoutElements.append(textTitle)
        
        if let subtitleText = textSubtitle.attributedText, !subtitleText.string.isEmpty {
            contentLayoutElements.append(textSubtitle)
        }
        
        let stackLayoutContent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5.0,
            justifyContent: .start,
            alignItems: .start,
            children: contentLayoutElements)
        
        let stackLayoutButton = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10.0,
            justifyContent: .end,
            alignItems: .end,
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
        
        let padding: CGFloat = 20.0
        let inset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        let insetContentLayout = ASInsetLayoutSpec(insets: inset, child: stackLayoutContent)
        let insetButtonLayout = ASInsetLayoutSpec(insets: inset, child: stackLayoutButtonContainer)
        
        let stackContainer = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 2.0,
            justifyContent: .start,
            alignItems: .start,
            children: [
                insetContentLayout,
                separator,
                insetButtonLayout
            ])
        
        return stackContainer
    }
}
