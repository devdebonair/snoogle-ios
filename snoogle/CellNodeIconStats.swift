//
//  CellNodeIconStats.swift
//  snoogle
//
//  Created by Vincent Moore on 8/2/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeIconStats: CellNode {
    let iconImageNode = ASNetworkImageNode()
    let statLeftTitleNode = ASTextNode()
    let statRightTitleNode = ASTextNode()
    let statLeftSubtitleNode = ASTextNode()
    let statRightSubtitleNode = ASTextNode()
    
    override func didLoad() {
        super.didLoad()
        iconImageNode.cornerRadius = 50/2
        iconImageNode.clipsToBounds = true
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackStatRight = ASStackLayoutSpec(direction: .vertical, spacing: 4.0, justifyContent: .end, alignItems: .end, children: [statRightSubtitleNode, statRightTitleNode])
        let stackStatLeft = ASStackLayoutSpec(direction: .vertical, spacing: 4.0, justifyContent: .end, alignItems: .end, children: [statLeftSubtitleNode, statLeftTitleNode])
        let stackStatContainer = ASStackLayoutSpec(direction: .horizontal, spacing: 25, justifyContent: .end, alignItems: .stretch, children: [stackStatLeft, stackStatRight])
        let stackContainer = ASStackLayoutSpec(direction: .horizontal, spacing: 25, justifyContent: .spaceBetween, alignItems: .center, children: [iconImageNode, stackStatContainer])
        iconImageNode.style.preferredSize = CGSize(width: 50, height: 50)
        iconImageNode.style.flexShrink = 1.0
        stackContainer.style.flexGrow = 1.0
        return stackContainer
    }
}
