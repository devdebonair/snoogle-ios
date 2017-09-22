//
//  CellNodeButtonBar.swift
//  snoogle
//
//  Created by Vincent Moore on 1/4/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CellNodeArticleButtonBar: ASCellNode {
    
    let separatorTop = ASDisplayNode()
    let separatorBottom = ASDisplayNode()
    let actionBar: CellNodePostActionBar
    
    let COLOR_DISABLED = UIColor(red: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
    
    init(vote: VoteType = .none, saved: Bool = false, numberOfComments: Int = 0) {
        actionBar = CellNodePostActionBar(vote: vote, saved: saved, numberOfComments: numberOfComments)
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        separatorTop.backgroundColor = COLOR_DISABLED
        separatorBottom.backgroundColor = COLOR_DISABLED
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonInset = UIEdgeInsets(top: 15, left: 20.0, bottom: 15, right: 20.0)
        let insetButtonLayout = ASInsetLayoutSpec(insets: buttonInset, child: actionBar)
        
        separatorTop.style.width = ASDimension(unit: .fraction, value: 1.0)
        separatorTop.style.height = ASDimension(unit: .points, value: 1.0)
        
        separatorBottom.style.width = ASDimension(unit: .fraction, value: 1.0)
        separatorBottom.style.height = ASDimension(unit: .points, value: 1.0)
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical, spacing: 0.0, justifyContent: .start, alignItems: .start, children: [separatorTop, insetButtonLayout, separatorBottom])
        
        return stackLayout
    }
}
