//
//  MediaAlbum.swift
//  snoogle
//
//  Created by Vincent Moore on 1/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class NodeMediaAlbum: ASDisplayNode {
    
    let collectionNode: ASCollectionNode
    let flowLayout: UICollectionViewFlowLayout
    var media: [MediaElement]
    
    init(media: [MediaElement]) {
        self.media = media
        flowLayout = UICollectionViewFlowLayout()
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        collectionNode.backgroundColor = .clear
        collectionNode.frame = frame
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    override func didLoad() {
        super.didLoad()
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }

}

extension NodeMediaAlbum: ASCollectionDelegate, ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = media[indexPath.section]
        return { _ -> ASCellNode in
            return CellNodeMedia(media: [model])
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let height: CGFloat = collectionNode.frame.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
        let width: CGFloat = CGFloat(FLT_MAX)
        let max = CGSize(width: width, height: height)
        let min = CGSize(width: 0.0, height: height)
        return ASSizeRange(min: min, max: max)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return media.count
    }
}
