//
//  MenuSubredditSettingsViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 5/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MenuSubredditSettingsViewModel: NSObject, ViewModelElement {
    private enum CellType: Int {
        case rules = 1
        case favorite = 2
        case multireddit = 3
        case resize = 4
        case seperator = 5
    }
    
    private let cellTypes: [CellType] = [
        .rules,
        .seperator,
        .favorite,
        .seperator,
        .multireddit,
        .seperator,
        .resize,
        .seperator
    ]
    
    override init() {
        super.init()
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellTypes[index]
        switch type {
        case .rules:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "rules"), title: "Rules")
        case .favorite:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "favorite"), title: "Favorite")
        case .multireddit:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "multireddit"), title: "Add to Multireddit")
        case .resize:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "resize"), title: "Resize Posts")
        case .seperator:
            return CellNodeSeparator()
        }
    }
    
    func header() -> ASCellNode? {
        return Header(text: "Subreddit Settings")
    }
    
    func headerSize() -> ASSizeRange {
        return ASSizeRangeUnconstrained
    }
    
    func numberOfCells() -> Int {
        return cellTypes.count
    }
}
