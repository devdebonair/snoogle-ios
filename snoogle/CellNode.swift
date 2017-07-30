//
//  CellNode.swift
//  snoogle
//
//  Created by Vincent Moore on 7/30/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNode: ASCellNode {
    var hasSeparator: Bool = false
    var separatorColor: UIColor = .clear
    var inset: UIEdgeInsets = .zero
    var didLoadBlock: ((CellNode)->Void)? = nil
    private lazy var separator: ASDisplayNode? = {
        return self.hasSeparator ? ASDisplayNode() : nil
    }()
    
    init(didLoad: ((CellNode)->Void)? = nil) {
        self.didLoadBlock = didLoad
        super.init()
    }
    
    func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
    override func didLoad() {
        if let didLoadBlock = didLoadBlock {
            didLoadBlock(self)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentLayout = ASInsetLayoutSpec(insets: inset, child: buildLayout(constrainedSize: constrainedSize))
        if let separator = separator {
            separator.style.width = ASDimension(unit: .fraction, value: 1.0)
            separator.style.height = ASDimension(unit: .points, value: 1.0)
            separator.backgroundColor = separatorColor
            let insetSeparator = ASInsetLayoutSpec(insets: separatorInset, child: separator)
            let stack = ASStackLayoutSpec(
                direction: .vertical,
                spacing: 0,
                justifyContent: .start,
                alignItems: .start,
                children: [
                    contentLayout,
                    insetSeparator])
            return stack
        }
        return contentLayout
    }
}
