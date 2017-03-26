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
        guard let context = collectionContext else {
            return _ASCollectionViewCell()
        }
        return context.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    public func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    public func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return .zero
    }
    
    public func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let context = collectionContext  else {
            return UICollectionReusableView()
        }
        return context.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: UICollectionReusableView.self, at: index)
    }
    
    public func supportedElementKinds() -> [String] {
        return []
    }
}
