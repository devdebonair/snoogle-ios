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
    let separator = ASDisplayNode()
    let numberOfGutters: Int
    let gutterColor: UIColor
    
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
        
        separator.backgroundColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        separator.style.height = ASDimension(unit: .points, value: 1.0)
        
        let stackLayoutText = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [
                textMeta,
                textBody
            ])
        
        let insetLayoutText = ASInsetLayoutSpec(insets: inset, child: stackLayoutText)
        
        let stackLayoutTextSeparatorContainer = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            children: [
                separator,
                insetLayoutText
            ])
        
        stackLayoutTextSeparatorContainer.style.flexShrink = 1.0

        var gutterNodes = [ASLayoutElement]()
        for _ in 0..<numberOfGutters {
            let node = ASDisplayNode()
            node.backgroundColor = gutterColor
            node.style.preferredSize = CGSize(width: 5.0, height: 0)
            node.isLayerBacked = true
            gutterNodes.append(node)
        }
    
        let stackLayoutGutters = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 4.0,
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
                stackLayoutTextSeparatorContainer])
        
        return stackLayoutCommentContainer
    }
}
