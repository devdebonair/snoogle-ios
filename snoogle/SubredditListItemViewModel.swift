//
//  SubredditListItemViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 6/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SubredditListItemViewModel: NSObject, ViewModelElement {
    let name: String
    let numberOfSubscribers: Int
    let imageUrl: URL?
    
    init(name: String, subscribers: Int, imageUrl: URL?) {
        self.name = name
        self.numberOfSubscribers = subscribers
        self.imageUrl = imageUrl
    }
    
    func cell(index: Int) -> ASCellNode {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let subcribersWithCommas = numberFormatter.string(from: NSNumber(value: numberOfSubscribers))!
        return CellNodeSubredditListItem(title: name, subtitle: "\(subcribersWithCommas) Subcribers", url: imageUrl, imageHeight: 55.0)
    }
    
    func numberOfCells() -> Int {
        return 1
    }
}
