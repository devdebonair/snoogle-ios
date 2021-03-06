//
//  SubredditIconStatViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/3/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class SubredditIconStatViewModel: NSObject, ViewModelElement {
    
    let url: URL?
    let numberOfSubscribers: Int
    let created: Date
    let bannerPhoto: Photo
    
    init(subreddit: Subreddit) {
        self.url = subreddit.urlValidImage
        self.numberOfSubscribers = subreddit.subscribers
        self.created = subreddit.created
        self.bannerPhoto = Photo(width: 414, height: 137, url: nil, urlSmall: nil, urlMedium: nil, urlLarge: nil, urlHuge: subreddit.urlBannerImage, info: nil)
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let cell = CellNodeBannerIconStats(banner: self.bannerPhoto)
        cell.iconStatCellNode.iconImageNode.url = url
        cell.iconStatCellNode.inset = UIEdgeInsets(top: 15, left: 25, bottom: 25, right: 25)
        cell.backgroundColor = ThemeManager.cellBackground()
        cell.iconStatCellNode.statLeftTitleNode.attributedText = NSMutableAttributedString(
            string: "Subscribers",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightHeavy),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()])
        cell.iconStatCellNode.statRightTitleNode.attributedText = NSMutableAttributedString(
            string: "Created",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightHeavy),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()])
        cell.iconStatCellNode.statLeftSubtitleNode.attributedText = NSMutableAttributedString(
            string: NSNumber(value: numberOfSubscribers).convertToCommaWithString() ?? "\(numberOfSubscribers)",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightBold),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()])
        cell.iconStatCellNode.statRightSubtitleNode.attributedText = NSMutableAttributedString(
            string: "\(created.timeAgo(numericDates: true, shortened: true))",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightBold),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()])
        return cell
    }
}
