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

class CellNodeText: CellNode {
    let textNode = ASTextNode()
    
    init(attributedText: NSMutableAttributedString) {
        super.init()
        textNode.attributedText = attributedText
        textNode.maximumNumberOfLines = 0
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: textNode)
    }
}
