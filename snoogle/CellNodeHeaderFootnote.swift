//
//  CellNodeHeaderFootnote.swift
//  snoogle
//
//  Created by Vincent Moore on 7/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeHeaderFootnote: ASCellNode {
    let textNodeHeader = ASTextNode()
    let textNodeFootnote = ASTextNode()
    var inset: UIEdgeInsets = .zero
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 20.0, justifyContent: .spaceBetween, alignItems: .start, children: [textNodeHeader, textNodeFootnote])
        return ASInsetLayoutSpec(insets: inset, child: stack)
    }
}
