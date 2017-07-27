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
        
        collectionNode.backgroundColor = .clear
        collectionNode.frame = frame
        
        flowLayout.scrollDirection = .horizontal
    }
    
    override func didLoad() {
        super.didLoad()
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
        collectionNode.view.isDirectionalLockEnabled = true
        collectionNode.view.alwaysBounceVertical = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }
}

extension CellNodePagerHeader: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let title = sections[indexPath.section]
        let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let text = NSMutableAttributedString(
            string: title,
            attributes: [
                NSForegroundColorAttributeName: textColor,
                NSFontAttributeName: textFont
            ])
        return { _ -> ASCellNode in
            return CellNodeText(attributedText: text, inset: inset)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let height: CGFloat = collectionNode.frame.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
        let width: CGFloat = collectionNode.frame.width / CGFloat(4.0)
        print(width)
        let max = CGSize(width: width, height: height)
        let min = CGSize(width: width, height: height)
        return ASSizeRange(min: min, max: max)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return sections.count
    }
}
