//
//  CellNodeComment.swift
//  snoogle
//
//  Created by Vincent Moore on 1/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CellNodeComment: ASCellNode {
    
    let inset: UIEdgeInsets
    let textMeta = ASTextNode()
    let textBody = ASTextNode()
    let numberOfGutters: Int
    let gutterColor: UIColor
    let backgroundNode = ASDisplayNode()
    
    init(meta: NSMutableAttributedString, body: NSMutableAttributedString, inset: UIEdgeInsets = .zero, numberOfGutters: Int = 0, gutterColor: UIColor = .lightGray) {
        self.inset = inset
        self.numberOfGutters = numberOfGutters
        self.gutterColor = gutterColor
        
        super.init()
        
        textMeta.isLayerBacked = true
        textMeta.attributedText = meta
        textMeta.maximumNumberOfLines = 0
        
        textBody.isLayerBacked = true
        textBody.attributedText = body
        textBody.maximumNumberOfLines = 0
        
        backgroundNode.isLayerBacked = true
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
                
        let stackLayoutText = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                textMeta,
                textBody
            ])
        
        let insetLayoutText = ASInsetLayoutSpec(insets: inset, child: stackLayoutText)
        
        insetLayoutText.style.flexShrink = 1.0
        
        var gutterNodes = [ASLayoutElement]()
        for _ in 0..<numberOfGutters {
            let node = ASDisplayNode()
            node.backgroundColor = gutterColor
            node.style.width = ASDimension(unit: .points, value: 1.0)
            node.style.height = ASDimension(unit: .fraction, value: 1.0)
            node.style.preferredSize = CGSize(width: 1.0, height: 0.0)
            node.isLayerBacked = true
            gutterNodes.append(node)
        }
    
        let stackLayoutGutters = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 15.0,
            justifyContent: .start,
            alignItems: .stretch,
            children: gutterNodes)
        
        let stackLayoutCommentContainer = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0.0,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
                stackLayoutGutters,
                insetLayoutText])
        
        
        let containerInset = UIEdgeInsets(top: 0, left: inset.left, bottom: 0, right: 0)
        let insetLayoutContainer = ASInsetLayoutSpec(insets: containerInset, child: stackLayoutCommentContainer)
        
        backgroundNode.style.height = ASDimension(unit: .points, value: 10.0)
        backgroundNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        backgroundNode.backgroundColor = gutterColor
        
        let containerWithBackground = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            children: [])
        
        // ignore inset and gutters if they are empty
        let isFirst = gutterNodes.isEmpty
        if isFirst {
            containerWithBackground.children?.append(backgroundNode)
            containerWithBackground.children?.append(insetLayoutText)
        } else {
            containerWithBackground.children?.append(insetLayoutContainer)
        }
        
        containerWithBackground.style.width = ASDimension(unit: .points, value: constrainedSize.max.width)
        
        return containerWithBackground
    }
}
