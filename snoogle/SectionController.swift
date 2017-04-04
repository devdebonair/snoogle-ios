//
//  SectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 3/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class SectionController: IGListSectionController, ASSectionController, ASSupplementaryNodeSource {
    
    var model: ViewModelElement!
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        return ASSizeRangeZero
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return { _ -> ASCellNode in
            return ASCellNode()
        }
    }
    
    override func numberOfItems() -> Int {
        return 0
    }
    
    func beginBatchFetch(with context: ASBatchContext) {
        if let controller = viewController as? CollectionController, controller.shouldFetch() {
            controller.fetch(context: context)
        }
    }
    
    func nodeForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASCellNode {
        let header = model.header()
        let footer = model.footer()
        
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            if let header = header { return header }
        case UICollectionElementKindSectionFooter:
            if let footer = footer { return footer }
        default:
            return ASCellNode()
        }
        
        return ASCellNode()
    }
    
    func sizeRangeForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASSizeRange {
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            return model.headerSize()
        case UICollectionElementKindSectionFooter:
            return model.footerSize()
        default:
            return ASSizeRangeZero
        }
    }
    
    override func didUpdate(to object: Any) {}
    override func didSelectItem(at index: Int) {}
    
    override func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader, UICollectionElementKindSectionFooter]
    }
}
