//
//  CellNodeMediaGrid.swift
//  snoogle
//
//  Created by Vincent Moore on 7/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeMediaGrid: ASCellNode {
    
    let collectionNode: ASCollectionNode
    let flowLayout: UICollectionViewFlowLayout
    var numberOfColumns: Int = 1
    let models: [ViewModelElement]
    
    init(models: [ViewModelElement]) {
        self.models = models
        self.flowLayout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        collectionNode.backgroundColor = .clear
        collectionNode.frame = frame
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
    }
    
    override func didLoad() {
        super.didLoad()
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
        collectionNode.view.isDirectionalLockEnabled = true
        collectionNode.view.alwaysBounceVertical = false
        collectionNode.view.alwaysBounceHorizontal = false
        collectionNode.view.isScrollEnabled = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let numberOfRows: CGFloat = CGFloat(models.count/numberOfColumns)
        let height: CGFloat = (constrainedSize.max.width / CGFloat(numberOfColumns)) * numberOfRows
        collectionNode.style.height = ASDimension(unit: .points, value: height)
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }
}

extension CellNodeMediaGrid: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = models[indexPath.row]
        return { _ -> ASCellNode in
            return model.cell(index: indexPath.section)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let width: CGFloat = (collectionNode.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)/CGFloat(numberOfColumns)
        let max = CGSize(width: width, height: width)
        return ASSizeRange(min: max, max: max)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
}
