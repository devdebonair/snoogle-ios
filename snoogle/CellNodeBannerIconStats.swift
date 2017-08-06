//
//  CellNodeBannerIconStats.swift
//  snoogle
//
//  Created by Vincent Moore on 8/4/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeBannerIconStats: CellNode {
    let bannerImageNode: CellNodeMedia
    let iconStatCellNode: CellNodeIconStats
    
    init(banner: MediaElement) {
        self.bannerImageNode = CellNodeMedia(media: banner)
        iconStatCellNode = CellNodeIconStats(didLoad: { (cell) in
            cell.backgroundColor = .white
            cell.cornerRadius = 10.0
            cell.shadowOffset = CGSize(width: 0, height: -1.0)
            cell.clipsToBounds = false
            cell.shadowOpacity = 0.20
            cell.shadowRadius = 1.0
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        })
        super.init()
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        iconStatCellNode.style.flexGrow = 1.0
        iconStatCellNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: -10.0, justifyContent: .start, alignItems: .start, children: [bannerImageNode, iconStatCellNode])
        return stack
    }
}
