//
//  SubredditListItemViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 6/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

protocol SubredditListItemViewModelDelegate {
    func didSelectSubreddit(subreddit: SubredditListItemViewModel)
}

class SubredditListItemViewModel: NSObject, ViewModelElement {
    let name: String
    let subtitle: String
    let imageUrl: URL?
    
    var delegate: SubredditListItemViewModelDelegate? = nil
    
    init(name: String, subtitle: String, imageUrl: URL?) {
        self.name = name
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
    
    func cell(index: Int) -> ASCellNode {
        let title = NSMutableAttributedString(
            string: self.name,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()
            ])
        
        let subtitle = NSMutableAttributedString(
            string: self.subtitle,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: ThemeManager.textSecondary()
            ])
        let cell = CellNodeSubredditListItem(title: title, subtitle: subtitle, url: imageUrl, imageHeight: 55.0)
        cell.backgroundColor = ThemeManager.cellBackground()
        return cell
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        delegate.didSelectSubreddit(subreddit: self)
    }
}
