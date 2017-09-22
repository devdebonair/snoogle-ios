//
//  Header.swift
//  CardTransition
//
//  Created by Vincent Moore on 2/23/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class Header: ASCellNode {
    
    let textNode = ASTextNode()
    let line = ASDisplayNode()
    let upperLine = ASDisplayNode()
    var inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    init(text: String) {
        textNode.attributedText = NSAttributedString(string: text, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        ])
        super.init()
        automaticallyManagesSubnodes = true
        line.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        upperLine.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        line.style.width = ASDimension(unit: .fraction, value: 1.0)
        line.style.height = ASDimension(unit: .points, value: 1.0)
        upperLine.style.width = ASDimension(unit: .fraction, value: 1.0)
        upperLine.style.height = ASDimension(unit: .points, value: 1.0)
        
        let insetSpec = ASInsetLayoutSpec(insets: inset, child: textNode)
        let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .center, alignItems: .center, children: [insetSpec])
        let verticalStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .center, children: [upperLine, stack, line])
        
        stack.style.flexGrow = 1.0
        verticalStack.style.width = ASDimension(unit: .fraction, value: 1.0)
        
        return verticalStack
    }
    
}
