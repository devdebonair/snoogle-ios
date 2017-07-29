//
//  CellNodeButtonTextLeft.swift
//  snoogle
//
//  Created by Vincent Moore on 7/28/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeButtonTextLeft: ASCellNode {
    let textNode = ASTextNode()
    let imageNode = ASImageNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacing: CGFloat = 15.0
        imageNode.style.preferredSize = CGSize(width: 11, height: 11)
        let stackLayout = ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: .start, alignItems: .center, children: [imageNode, textNode])
        let inset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return ASInsetLayoutSpec(insets: inset, child: stackLayout)
    }
}
