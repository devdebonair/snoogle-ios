//
//  CellNodeButtonTextLeft.swift
//  snoogle
//
//  Created by Vincent Moore on 7/28/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeButtonTextLeft: CellNode {
    let textNode = ASTextNode()
    let imageNode = ASImageNode()
    var imageSize: CGFloat = 11.0
    var spacing: CGFloat = 15.0
    
    var justify: ASStackLayoutJustifyContent = .start
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: imageSize, height: imageSize)
        return ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: justify, alignItems: .center, children: [imageNode, textNode])
    }
}
