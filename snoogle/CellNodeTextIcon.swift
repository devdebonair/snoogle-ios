//
//  CellNodeTextChevron.swift
//  snoogle
//
//  Created by Vincent Moore on 8/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeTextIcon: CellNode {
    let textNode = ASTextNode()
    let imageNode = ASImageNode()
    
    override init(didLoad: ((CellNode) -> Void)? = nil) {
        super.init(didLoad: didLoad)
        imageNode.style.preferredSize = CGSize(width: 15.0, height: 15.0)
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [textNode, imageNode])
        stack.style.width = ASDimension(unit: .fraction, value: 1.0)
        return stack
    }
}
