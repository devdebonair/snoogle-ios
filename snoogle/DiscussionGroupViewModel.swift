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

protocol DiscussionGroupViewModelDelegate {
    func didSelectDiscussion(discussion: DiscussionViewModel)
    func didSelectMoreDiscussions()
}

class DiscussionGroupViewModel: NSObject, ViewModelElement {
    enum CellType: Int {
        case discussion = 1
        case header = 2
        case footer = 3
    }
    
    let models: [DiscussionViewModel]
    var delegate: DiscussionGroupViewModelDelegate? = nil
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
                    NSForegroundColorAttributeName: ThemeManager.textPrimary()
                ])
            let cell = CellNodeText(attributedText: text)
            cell.inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
            cell.separatorColor = ThemeManager.background()
            cell.hasSeparator = true
            cell.backgroundColor = ThemeManager.cellBackground()
            return cell
            
        case .footer:
            let cell = CellNodeMoreChevron()
            let font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
            let attributes = NSMutableAttributedString(
                string: "More Discussions",
                attributes: [
                    NSFontAttributeName: font,
                    NSForegroundColorAttributeName: ThemeManager.textPrimary()
                ])
            cell.imageNode.image = #imageLiteral(resourceName: "right-chevron")
            cell.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(ThemeManager.cellAccessory())
            cell.textNode.attributedText = attributes
            cell.imageNode.contentMode = .scaleAspectFit
            cell.backgroundColor = ThemeManager.cellBackground()
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
        guard let delegate = delegate else { return }
        if index == cellOrder.count - 1 {
            return delegate.didSelectMoreDiscussions()
        }
        let subArr = Array(cellOrder[0...index])
        let filterdArr = subArr.filter { $0 == .discussion }
        let model = models[filterdArr.count-1]
        delegate.didSelectDiscussion(discussion: model)
    }
}
