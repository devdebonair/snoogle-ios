//
//  MenuComposeViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 5/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MenuComposeViewModel: NSObject, ViewModelElement {
    private enum CellType: Int {
        case image = 1
        case link = 2
        case discussion = 3
        case seperator = 4
    }
    
    private let cellTypes: [CellType] = [
        .image,
        .seperator,
        .link,
        .seperator,
        .discussion,
        .seperator,
    ]
    
    override init() {
        super.init()
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellTypes[index]
        switch type {
        case .image:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "picture"), title: "Post an Image")
        case .link:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "chains"), title: "Post a Link")
        case .discussion:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "talk"), title: "Start a Discussion")
        case .seperator:
            return CellNodeSeparator()
        }
    }
    
    func header() -> ASCellNode? {
        return Header(text: "Create a Post")
    }
    
    func headerSize() -> ASSizeRange {
        return ASSizeRangeUnconstrained
    }
    
    func numberOfCells() -> Int {
        return cellTypes.count
    }
}
