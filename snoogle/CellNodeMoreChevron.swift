//
//  CellNodeMoreChevron.swift
//  snoogle
//
//  Created by Vincent Moore on 7/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeMoreChevron: ASCellNode {
    let textNode = ASTextNode()
    let imageNode = ASImageNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backgroundColor = .white
        self.clipsToBounds = false
        self.shadowOpacity = 0.20
        self.shadowRadius = 1.0
        self.cornerRadius = 2.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: 11, height: 11)
        let stackLayout = ASStackLayoutSpec(direction: .horizontal, spacing: 15.0, justifyContent: .center, alignItems: .center, children: [textNode, imageNode])
        let centerLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: stackLayout)
        let inset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return ASInsetLayoutSpec(insets: inset, child: centerLayout)
    }
}
