//
//  DiscussionGroupViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RealmSwift

class DiscussionGroupViewModel: NSObject, ViewModelElement {
    enum CellType: Int {
        case discussion = 1
        case header = 2
        case footer = 3
    }
    
    let models: [DiscussionViewModel]
    var cellOrder: [CellType] {
        var order = [CellType]()
        order.append(.header)
        for _ in self.models {
            order.append(.discussion)
        }
        order.append(.footer)
        return order
    }
    
    init(submissions: List<Submission>) {
        models = submissions.map({ (submission) -> DiscussionViewModel in
            return DiscussionViewModel(submission: submission)
        })
    }
    
    func cell(index: Int) -> ASCellNode {
        let type = cellOrder[index]
        
        switch type {
        case .header:
            let text = NSMutableAttributedString(
                string: "Discussions",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                    NSForegroundColorAttributeName: UIColor.darkText
                ])
            let cell = CellNodeText(attributedText: text)
            cell.inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
            let colorValue: Float = 240/255
            cell.separatorColor = UIColor(colorLiteralRed: colorValue, green: colorValue, blue: colorValue, alpha: 1.0)
            cell.hasSeparator = true
            cell.backgroundColor = .white
            return cell
            
        case .footer:
            let cell = CellNodeMoreChevron()
            let font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
            let color = UIColor(colorLiteralRed: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
            let attributes = NSMutableAttributedString(
                string: "More Discussions",
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
            
        case .discussion:
            let subArr = Array(cellOrder[0...index])
            let filterdArr = subArr.filter { $0 == .discussion }
            let model = models[filterdArr.count-1]
            return model.cell(index: 0)
        }
    }
    
    func numberOfCells() -> Int {
        return cellOrder.count
    }
    
    func didSelect(index: Int) {
        //        guard let delegate = delegate else { return }
        //        delegate.didSelectSubreddit(subreddit: self)
    }
}
