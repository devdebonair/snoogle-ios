//
//  CellNodePagerHeader.swift
//  snoogle
//
//  Created by Vincent Moore on 7/26/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodePagerHeader: ASDisplayNode {
    
    let collectionNode: ASCollectionNode
    let flowLayout: UICollectionViewFlowLayout
    let selectionBar = ASDisplayNode()
    let sections: [String]
    
    var textColor: UIColor = .darkText
    var textFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    init(sections: [String]) {
        self.sections = sections
        self.flowLayout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        collectionNode.backgroundColor = .clear
        collectionNode.frame = frame
        
        flowLayout.scrollDirection = .horizontal
        
        selectionBar.backgroundColor = UIColor(colorLiteralRed: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
    }
    
    override func didLoad() {
        super.didLoad()
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
        collectionNode.view.isDirectionalLockEnabled = true
        collectionNode.view.alwaysBounceVertical = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        selectionBar.style.height = ASDimension(unit: .points, value: 2.0)
        selectionBar.style.width = ASDimension(unit: .fraction, value: 0.25)
        collectionNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        collectionNode.style.height = ASDimension(unit: .points, value: 42)
        let stackLayout = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [collectionNode, selectionBar])
        return stackLayout
    }
}

extension CellNodePagerHeader: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let title = sections[indexPath.section]
        let text = NSMutableAttributedString(
            string: title,
            attributes: [
                NSForegroundColorAttributeName: textColor,
                NSFontAttributeName: textFont
            ])
        return { _ -> ASCellNode in
            return CellNodeTextCenter(attributedText: text, inset: .zero)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let height: CGFloat = collectionNode.frame.height
        let width: CGFloat = collectionNode.frame.width / CGFloat(4.0)
        let max = CGSize(width: width, height: 0)
        let min = CGSize(width: width, height: height)
        return ASSizeRange(min: min, max: max)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return sections.count
    }
}
