//
//  GenericSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/12/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class GenericSectionController: IGListSectionController, ASSectionController, ASSupplementaryNodeSource {
    
    var model: ViewModelElement!
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        guard let context = collectionContext else { return ASSizeRangeUnconstrained }
        return model.cellSize(at: index, context: context)
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let model = self.model
        return { _ -> ASCellNode in
            guard let model = model else { return ASCellNode() }
            return model.cell(index: index)
        }
    }
    
    override func numberOfItems() -> Int {
        guard let model = model else { return 0 }
        return model.numberOfCells()
    }
    
    func beginBatchFetch(with context: ASBatchContext) {
        guard let controller = viewController as? CollectionController, controller.shouldFetch() else { return }
        controller.fetch(context: context)
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
        guard let object = object as? ViewModelElement else { return }
        self.model = object
    }
    
    override func didSelectItem(at index: Int) {
        self.model.didSelect(index: index)
    }
    
    override func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader, UICollectionElementKindSectionFooter]
    }
}
