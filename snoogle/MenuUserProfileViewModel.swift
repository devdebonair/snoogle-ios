//
//  MenuUserProfileViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 5/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class MenuUserProfileViewModel: NSObject, ViewModelElement {
    private enum CellType: Int {
        case stat = 1
        case friends = 2
        case message = 3
        case posts = 4
        case comments = 5
        case seperator = 6
    }
    
    private let cellTypes: [CellType] = [
        .stat,
        .seperator,
        .friends,
        .seperator,
        .message,
        .seperator,
        .posts,
        .seperator,
        .comments,
        .seperator
    ]
    
    override init() {
        super.init()
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellTypes[index]
        switch type {
        case .stat:
            return CellNodeUserKarma(age: Date(), karma: 254)
        case .friends:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "friend-add"), title: "Add to Friends List")
        case .posts:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "post"), title: "View Posts")
        case .message:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "send-message"), title: "Send Message")
        case .comments:
            return CellNodeMenuItem(image: #imageLiteral(resourceName: "comments"), title: "View Comments")
        case .seperator:
            return CellNodeSeparator()
        }
    }
    
    func header() -> ASCellNode? {
        return Header(text: "Catalystlive")
    }
    
    func headerSize() -> ASSizeRange {
        return ASSizeRangeUnconstrained
    }
    
    func numberOfCells() -> Int {
        return cellTypes.count
    }
}
