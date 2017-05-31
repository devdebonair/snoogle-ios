//
//  SubmissionSortViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 5/29/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SubmissionSortViewModel: NSObject, ViewModelElement {
    
    private enum CellType: Int {
        case hot = 1
        case new = 2
        case rising = 3
        case top = 4
        case seperator = 5
    }
    
    private let cellTypes: [CellType] = [
        .hot,
        .seperator,
        .new,
        .seperator,
        .rising,
        .seperator,
        .top,
        .seperator,
    ]
    
    override init() {
        super.init()
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellTypes[index]
        switch type {
        case .hot:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "burn"), title: "Hot")
        case .new:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "new"), title: "New")
        case .rising:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "analytics"), title: "Rising")
        case .top:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "favorite"), title: "Top")
        case .seperator:
            return CellNodeSeparator()
        }
    }
    
    func header() -> ASCellNode? {
        return Header(text: "Sort Listings")
    }
    
    func headerSize() -> ASSizeRange {
        return ASSizeRangeUnconstrained
    }
    
    func numberOfCells() -> Int {
        return cellTypes.count
    }
}
