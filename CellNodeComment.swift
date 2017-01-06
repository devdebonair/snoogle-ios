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
    
    let textMeta = ASTextNode()
    let textBody = ASTextNode()
    
    let inset: UIEdgeInsets
    
    init(meta: NSMutableAttributedString, body: NSMutableAttributedString, inset: UIEdgeInsets = .zero) {
        self.inset = inset
        super.init()
        textMeta.attributedText = meta
        textMeta.maximumNumberOfLines = 0
        
        textBody.attributedText = body
        textBody.maximumNumberOfLines = 0
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackLayout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [
                textMeta,
                textBody
            ])
        
        let insetLayout = ASInsetLayoutSpec(insets: inset, child: stackLayout)
        
        return insetLayout
    }
}
