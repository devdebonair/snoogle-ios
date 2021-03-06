//
//  CellNode.swift
//  snoogle
//
//  Created by Vincent Moore on 7/30/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import Hero

class CellNode: ASCellNode {
    var hasSeparator: Bool = false
    var separatorColor: UIColor = .clear {
        didSet {
            self.separator?.backgroundColor = separatorColor
        }
    }
    var separatorThickness: CGFloat = 1.0
    var inset: UIEdgeInsets = .zero
    var didLoadBlock: ((CellNode)->Void)? = nil
    private lazy var separator: ASDisplayNode? = {
        return self.hasSeparator ? ASDisplayNode() : nil
    }()
    
    init(didLoad: ((CellNode)->Void)? = nil) {
        self.didLoadBlock = didLoad
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
    override func didLoad() {
        self.view.heroID = UUID().uuidString
        if let didLoadBlock = didLoadBlock {
            didLoadBlock(self)
        }
    }
    
    func willBuildLayout(constrainedSize: ASSizeRange) {}
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.willBuildLayout(constrainedSize: constrainedSize)
        let contentLayout = ASInsetLayoutSpec(insets: inset, child: buildLayout(constrainedSize: constrainedSize))
        contentLayout.style.width = ASDimension(unit: .fraction, value: 1.0)
        if let separator = separator {
            separator.style.width = ASDimension(unit: .fraction, value: 1.0)
            separator.style.height = ASDimension(unit: .points, value: separatorThickness)
            separator.backgroundColor = separatorColor
            let insetSeparator = ASInsetLayoutSpec(insets: separatorInset, child: separator)
            let stack = ASStackLayoutSpec(
                direction: .vertical,
                spacing: 0,
                justifyContent: .start,
                alignItems: .stretch,
                children: [
                    contentLayout,
                    insetSeparator])
            stack.style.width = ASDimension(unit: .fraction, value: 1.0)
            return stack
        }
        return contentLayout
    }
}
