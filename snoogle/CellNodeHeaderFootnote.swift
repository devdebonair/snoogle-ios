//
//  CellNodeHeaderFootnote.swift
//  snoogle
//
//  Created by Vincent Moore on 7/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeHeaderFootnote: CellNode {
    let textNodeHeader = ASTextNode()
    let textNodeFootnote = ASTextNode()
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20.0,
            justifyContent: .spaceBetween,
            alignItems: .start,
            children: [
                textNodeHeader,
                textNodeFootnote])
    }
}
