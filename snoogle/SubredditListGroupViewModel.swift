//
//  SubredditListGroupViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RealmSwift

protocol SubredditListGroupViewModelDelegate {
    func didSelectSubreddit(subreddit: SubredditListItemViewModel)
    func didSelectMoreSubreddits()
}

class SubredditListGroupViewModel: NSObject, ViewModelElement {
    enum CellType: Int {
        case subreddit = 1
        case header = 2
        case footer = 3
    }
    
    let models: [SubredditListItemViewModel]
    var delegate: SubredditListGroupViewModelDelegate? = nil
    var cellOrder: [CellType] {
        var order = [CellType]()
        order.append(.header)
        for _ in self.models {
            order.append(.subreddit)
        }
        order.append(.footer)
        return order
    }
    
    init(subreddits: List<Subreddit>) {
        models = subreddits.map({ (subreddit) -> SubredditListItemViewModel in
            return SubredditListItemViewModel(name: subreddit.displayName, subtitle: subreddit.publicDescriptionStripped, imageUrl: subreddit.urlValidImage)
        })
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellOrder[index]
        
        switch type {
        case .header:
            let text = NSMutableAttributedString(
                string: "Subreddits",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                    NSForegroundColorAttributeName: UIColor.darkText
                ])
            let cell = CellNodeText(attributedText: text)
            cell.inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
            cell.hasSeparator = true
            let colorValue: CGFloat = 240/255
            cell.separatorColor = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 1.0)
            cell.backgroundColor = .white
            return cell

        case .footer:
            let cell = CellNodeMoreChevron()
            let font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
            let color = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
            let attributes = NSMutableAttributedString(
                string: "More Subreddits",
                attributes: [
                    NSFontAttributeName: font,
                    NSForegroundColorAttributeName: color
                ])
            cell.imageNode.image = #imageLiteral(resourceName: "right-chevron")
            cell.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
            cell.textNode.attributedText = attributes
            cell.imageNode.contentMode = .scaleAspectFit
            cell.backgroundColor = .white
            return cell

        case .subreddit:
            let subArr = Array(cellOrder[0...index])
            let filterdArr = subArr.filter { $0 == .subreddit }
            let model = models[filterdArr.count-1]
            let textColor: UIColor = .darkText
            let title = NSMutableAttributedString(
                string: model.name,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                    NSForegroundColorAttributeName: textColor
                ])
            
            let subtitle = NSMutableAttributedString(
                string: model.subtitle,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular),
                    NSForegroundColorAttributeName: textColor
                ])
            let cell = CellNodeSubredditListItem(title: title, subtitle: subtitle, url: model.imageUrl, imageHeight: 55.0)
            let colorValue: CGFloat = 240/255
            cell.hasSeparator = true
            cell.separatorColor = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 1.0)
            cell.textNodeSubtitle.maximumNumberOfLines = 2
            cell.backgroundColor = .white
            cell.inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
            return cell
        }
        
    }
    
    func numberOfCells() -> Int {
        return cellOrder.count
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        if index == cellOrder.count - 1 {
            return delegate.didSelectMoreSubreddits()
        }
        let subArr = Array(cellOrder[0...index])
        let filterdArr = subArr.filter { $0 == .subreddit }
        let model = models[filterdArr.count-1]
        delegate.didSelectSubreddit(subreddit: model)
    }
}

