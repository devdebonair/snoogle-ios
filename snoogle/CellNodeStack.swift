//
//  CellNodeStack.swift
//  snoogle
//
//  Created by Vincent Moore on 10/7/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeStack: CellNode {
    let stack = ASStackLayoutSpec()
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        stack.style.width = ASDimension(unit: .fraction, value: 1.0)
        return stack
    }
}
