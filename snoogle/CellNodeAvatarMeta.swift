//
//  CellNodeAvatarMeta.swift
//  snoogle
//
//  Created by Vincent Moore on 9/9/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeAvatarMeta: CellNode {
    
    let textNodeTitle = ASTextNode()
    let textNodeSubtitle = ASTextNode()
    let imageNode = ASNetworkImageNode()
    
    init() {
        super.init()
        
        textNodeTitle.isLayerBacked = true
        textNodeSubtitle.isLayerBacked = true
        imageNode.isLayerBacked = true
        
        textNodeTitle.maximumNumberOfLines = 1
        textNodeSubtitle.maximumNumberOfLines = 1
        
        imageNode.contentMode = .scaleAspectFill
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {        
        let textStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 2,
            justifyContent: .start,
            alignItems: .start,
            children: [textNodeTitle, textNodeSubtitle])
        
        let layout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            children: [imageNode, textStack])
        
        return layout
    }
}
