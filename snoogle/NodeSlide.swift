//
//  NodeSlide.swift
//  snoogle
//
//  Created by Vincent Moore on 1/11/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class NodeSlide: ASDisplayNode {
    
    let collectionNode: ASCollectionNode
    let flowLayout: UICollectionViewFlowLayout
    let models: [ViewModelElement]
        
    init(models: [ViewModelElement]) {
        self.models = models
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
        collectionNode.view.alwaysBounceHorizontal = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: collectionNode)
    }
}

extension NodeSlide: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = models[indexPath.section]
        return { _ -> ASCellNode in
            return model.cell(index: indexPath.row)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return models[section].numberOfCells()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let height: CGFloat = collectionNode.frame.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
        let width: CGFloat = CGFloat(Float.greatestFiniteMagnitude)
        let max = CGSize(width: width, height: height)
        let min = CGSize(width: 0.0, height: height)
        return ASSizeRange(min: min, max: max)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return models.count
    }
}
