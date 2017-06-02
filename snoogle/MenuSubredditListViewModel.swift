//
//  MenuSubredditListViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 6/2/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class MenuSubredditListViewModel: NSObject, ViewModelElement {
    let title: String
    let subtitle: String
    let url: URL?
    
    private enum CellType: Int {
        case subreddit = 0
        case seperator = 1
    }
    
    private let cellTypes: [CellType] = [
        .subreddit,
        .seperator
    ]
    
    init(title: String, subtitle: String, url: URL? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.url = url
        super.init()
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellTypes[index]
        switch type {
        case .subreddit:
            return CellNodeAvatarItem(title: title, subtitle: subtitle, url: url, imageHeight: 50)
        case .seperator:
            return CellNodeSeparator()
        }
    }
    
//    func header() -> ASCellNode? {
//        return Header(text: "Search Subreddit")
//    }
//    
//    func headerSize() -> ASSizeRange {
//        return ASSizeRangeUnconstrained
//    }
    
    func numberOfCells() -> Int {
        return cellTypes.count
    }
}
