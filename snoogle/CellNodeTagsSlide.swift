//
//  CellNodeTagsSlide.swift
//  snoogle
//
//  Created by Vincent Moore on 8/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeTagsSlide: CellNode {
    let tags: [TagViewModel]
    var tagsView: NodeSlide
    
    init(tags: [TagViewModel], didLoad: ((CellNode)->Void)? = nil) {
        self.tags = tags
        self.tagsView = NodeSlide(models: tags)
        super.init(didLoad: didLoad)
        if let layout = self.tagsView.collectionNode.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset.right = 10.0
        }
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: tagsView)
    }
}
