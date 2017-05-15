//
//  IGListSectionController+IGListSectionType.swift
//  snoogle
//
//  Created by Vincent Moore on 3/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

extension IGListSectionController: IGListSectionType, IGListSupplementaryViewSource {
    public func didUpdate(to object: Any) {}
    
    public func didSelectItem(at index: Int) {}
    
    public func numberOfItems() -> Int {
        return 0
    }
    
    public func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
    
    public func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }
    
    public func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return ASIGListSupplementaryViewSourceMethods.sizeForSupplementaryView(ofKind: elementKind, at: index)
    }
    
    public func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        return ASIGListSupplementaryViewSourceMethods.viewForSupplementaryElement(ofKind: elementKind, at: index, sectionController: self)
    }
    
    public func supportedElementKinds() -> [String] {
        return []
    }
}
