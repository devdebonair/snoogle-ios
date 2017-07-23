//
//  SubredditListGroupViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol SubredditListGroupViewModelDelegate {
    func didSelectSubreddit(subreddit: SubredditListItemViewModel)
}

class SubredditListGroupViewModel: NSObject, ViewModelElement {
    let name: String
    let content: String
    let imageUrl: URL?
    
    var delegate: SubredditListGroupViewModelDelegate? = nil
    
    init(name: String, subscribers: String, imageUrl: URL?) {
        self.name = name
        self.content = subscribers
        self.imageUrl = imageUrl
    }
    
    func cell(index: Int) -> ASCellNode {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        let subcribersWithCommas = numberFormatter.string(from: NSNumber(value: numberOfSubscribers))!
//        return CellNodeSubredditListItem(title: name, subtitle: "\(subcribersWithCommas) Subcribers", url: imageUrl, imageHeight: 55.0)
        return ASCellNode()
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
//        delegate.didSelectSubreddit(subreddit: self)
    }
}

