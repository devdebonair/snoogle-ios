//
//  ViewModelElement.swift
//  snoogle
//
//  Created by Vincent Moore on 1/4/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import IGListKit

protocol ViewModelElement {
    func numberOfCells() -> Int
    func cell(index: Int) -> ASCellNode
    func header() -> ASCellNode?
    func footer() -> ASCellNode?
    func headerSize() -> ASSizeRange
    func footerSize() -> ASSizeRange
    func cellSize(at index: Int, context: IGListCollectionContext) -> ASSizeRange
    func didSelect(index: Int)
}

extension ViewModelElement {
    func didSelect(index: Int) {
        return
    }
    
    func header() -> ASCellNode? {
        return nil
    }
    
    func footer() -> ASCellNode? {
        return nil
    }
    
    func headerSize() -> ASSizeRange {
        return ASSizeRangeZero
    }
    
    func footerSize() -> ASSizeRange {
        return ASSizeRangeZero
    }
    
    func cellSize(at index: Int, context: IGListCollectionContext) -> ASSizeRange {
        let width: CGFloat = context.containerSize.width
        let max = CGSize(width: width, height: CGFloat(Float.greatestFiniteMagnitude))
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
}
