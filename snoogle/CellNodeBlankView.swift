//
//  CellNodeBlankView.swift
//  snoogle
//
//  Created by Vincent Moore on 7/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeBlankView: ASCellNode {
    
    let displayNode = ASDisplayNode()
    
    init(color: UIColor) {
        super.init()
        automaticallyManagesSubnodes = true
        displayNode.isLayerBacked = true
        displayNode.backgroundColor = color
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: displayNode)
    }
}
