//
//  CellNodeText.swift
//  snoogle
//
//  Created by Vincent Moore on 1/3/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CellNodeText: ASCellNode {
    
    let textNode = ASTextNode()
    let inset: UIEdgeInsets
    
    init(attributedText: NSMutableAttributedString, inset: UIEdgeInsets = .zero) {
        self.inset = inset
        
        super.init()
        
        textNode.attributedText = attributedText
        textNode.maximumNumberOfLines = 0
        textNode.isLayerBacked = true
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: inset, child: textNode)
    }
    
}
