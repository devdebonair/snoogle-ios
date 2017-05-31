//
//  TextCell.swift
//  CardTransition
//
//  Created by Vincent Moore on 2/23/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class TextCell: ASCellNode {
    
    var inset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    let textNode = ASTextNode()
    
    init(text: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4.0
        textNode.attributedText = NSAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: style])
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: inset, child: textNode)
    }
    
    
}
