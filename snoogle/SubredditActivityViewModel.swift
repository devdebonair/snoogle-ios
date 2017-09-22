//
//  SubredditActivityViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/5/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SubredditActivityViewModel: NSObject, ViewModelElement {
    enum CellType: Int {
        case header = 0
        case stats = 1
        case discussions = 2
        case links = 3
    }
    let cellOrder: [CellType] = [.header, .stats, .discussions, .links]
    
    let status: String
    let lastPostDate: Date
    let percentageDiscussion: Float
    let percentageLinks: Float
    
    init(activity: SubredditActivity) {
        self.status = activity.status
        self.lastPostDate = activity.latestPostDate
        self.percentageDiscussion = Float(activity.percentageDiscussion)
        self.percentageLinks = Float(activity.percentageLink)
        super.init()
    }
    
    func numberOfCells() -> Int {
        return cellOrder.count
    }
    
    private func buildStatAttribute(_ string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: [
            NSForegroundColorAttributeName: UIColor(red: 45/255, green: 46/255, blue: 48/255, alpha: 1.0),
            NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
        ])
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellOrder[index]
        switch type {
        case .header:
            let header = NSMutableAttributedString(
                string: "ACTIVITY",
                attributes: [
                    NSKernAttributeName: CGFloat(1.3),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightHeavy),
                    NSForegroundColorAttributeName: UIColor(red: 45/255, green: 46/255, blue: 48/255, alpha: 1.0)
                ])
            let cell = CellNodeText(attributedText: header)
            cell.inset = UIEdgeInsets(top: 20, left: 25, bottom: 15, right: 25)
            return cell
        case .stats:
            let cell = CellNodeInfoDictionary()
            cell.dictionary = [
                self.buildStatAttribute("Status:"): self.buildStatAttribute(status.capitalized),
                self.buildStatAttribute("Last Post:"): self.buildStatAttribute(lastPostDate.timeAgo().capitalized)
            ]
            cell.spacingHorizontal = 15.0
            cell.spacingVertical = 15.0
            cell.inset = UIEdgeInsets(top: 0, left: 25, bottom: 15, right: 25)
            return cell
        case .discussions:
            let cell = CellNodeActivity()
            let progressColor = UIColor(red: 26/255, green: 206/255, blue: 206/255, alpha: 1.0)
            let trackColor = UIColor.lightGray
            let progressString = "\(Int(self.percentageDiscussion * 100))%"
            cell.set(progressColor: progressColor)
            cell.set(trackColor: trackColor)
            cell.set(progress: self.percentageDiscussion)
            cell.textNodeProgress.attributedText = NSMutableAttributedString(
                string: progressString,
                attributes: [
                    NSForegroundColorAttributeName: UIColor(red: 45/255, green: 46/255, blue: 48/255, alpha: 1.0),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
                ])
            cell.textNodeLabel.attributedText = NSMutableAttributedString(
                string: "Discussions",
                attributes: [
                    NSForegroundColorAttributeName: UIColor(red: 45/255, green: 46/255, blue: 48/255, alpha: 1.0),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
                ])
            cell.inset = UIEdgeInsets(top: 0, left: 25, bottom: 15, right: 25)
            return cell
        case .links:
            let cell = CellNodeActivity()
            let progressColor = UIColor(red: 26/255, green: 206/255, blue: 206/255, alpha: 1.0)
            let trackColor = UIColor.lightGray
            let progressString = "\(Int(self.percentageLinks * 100))%"
            cell.set(progressColor: progressColor)
            cell.set(trackColor: trackColor)
            cell.set(progress: self.percentageLinks)
            cell.textNodeProgress.attributedText = NSMutableAttributedString(
                string: progressString,
                attributes: [
                    NSForegroundColorAttributeName: UIColor(red: 45/255, green: 46/255, blue: 48/255, alpha: 1.0),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
                ])
            cell.textNodeLabel.attributedText = NSMutableAttributedString(
                string: "Links & Media",
                attributes: [
                    NSForegroundColorAttributeName: UIColor(red: 45/255, green: 46/255, blue: 48/255, alpha: 1.0),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
                ])
            cell.inset = UIEdgeInsets(top: 0, left: 25, bottom: 30, right: 25)
            cell.hasSeparator = true
            cell.separatorColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
            cell.separatorThickness = 2.0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
            return cell
        }
    }
}
