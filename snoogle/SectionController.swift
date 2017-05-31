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
        guard let context = collectionContext else {
            return ASSizeRangeUnconstrained
        }
        let width: CGFloat = context.containerSize.width - self.inset.left - self.inset.right
        let max = CGSize(width: width, height: CGFloat(Float.greatestFiniteMagnitude))
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let model = self.model
        return { _ -> ASCellNode in
            if let model = model {
                return model.cell(index: index)
            }
            return ASCellNode()
        }
    }
    
    override func numberOfItems() -> Int {
        if let model = model {
            return model.numberOfCells()
        }
        return 0
    }
    
    func beginBatchFetch(with context: ASBatchContext) {
        if let controller = viewController as? CollectionController, controller.shouldFetch() {
            controller.fetch(context: context)
        }
    }
    
    func nodeBlockForSupplementaryElement(ofKind elementKind: String, at index: Int) -> ASCellNodeBlock {
        let header = model.header()
        let footer = model.footer()
        return { _ -> ASCellNode in
            
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
    
    override func didUpdate(to object: Any) {
        if let object = object as? ViewModelElement {
            model = object
        }
    }
    
    override func didSelectItem(at index: Int) {}
    
    override func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader, UICollectionElementKindSectionFooter]
    }
}
