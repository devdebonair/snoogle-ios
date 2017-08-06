//
//  CellNodeInfoDicitonary.swift
//  snoogle
//
//  Created by Vincent Moore on 8/6/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeInfoDictionary: CellNode {
    var dictionary: [NSMutableAttributedString:NSMutableAttributedString] = [:]
    var spacingVertical: CGFloat = 10.0
    var spacingHorizontal: CGFloat = 10.0
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackKeys = ASStackLayoutSpec(direction: .vertical, spacing: spacingVertical, justifyContent: .start, alignItems: .start, children: [])
        let stackValues = ASStackLayoutSpec(direction: .vertical, spacing: spacingVertical, justifyContent: .start, alignItems: .start, children: [])
        for (key, value) in dictionary {
            let textNodeKey = ASTextNode()
            let textNodeValue = ASTextNode()
            textNodeKey.attributedText = key
            textNodeValue.attributedText = value
            stackKeys.children?.append(textNodeKey)
            stackValues.children?.append(textNodeValue)
        }
        let stackContainer = ASStackLayoutSpec(direction: .horizontal, spacing: spacingHorizontal, justifyContent: .start, alignItems: .start, children: [stackKeys, stackValues])
        return stackContainer
    }
}
