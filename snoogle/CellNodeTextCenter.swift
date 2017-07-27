//
//  CellNodeTextCenter.swift
//  snoogle
//
//  Created by Vincent Moore on 7/26/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CellNodeTextCenter: ASCellNode {
    
    let textNode = ASTextNode()
    let inset: UIEdgeInsets
    
    init(attributedText: NSMutableAttributedString, inset: UIEdgeInsets = .zero) {
        self.inset = inset
        
        super.init()
        
        textNode.attributedText = attributedText
        textNode.maximumNumberOfLines = 0
        //        textNode.isLayerBacked = true
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let centerLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: textNode)
        return ASInsetLayoutSpec(insets: inset, child: centerLayout)
    }
    
}
