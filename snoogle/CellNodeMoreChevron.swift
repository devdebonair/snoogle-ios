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
    let buttonNode = ASButtonNode()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let centerLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: buttonNode)
        let inset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return ASInsetLayoutSpec(insets: inset, child: centerLayout)
    }
}
