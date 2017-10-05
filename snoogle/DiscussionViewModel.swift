//
//  DiscussionViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol DiscussionViewModelDelegate {
    func didSelectDiscussion(discussion: DiscussionViewModel)
}

class DiscussionViewModel: NSObject, ViewModelElement {
    let id: String
    let title: String
    let meta: String
    
    var delegate: DiscussionViewModelDelegate? = nil
    
    init(submission: Submission) {
        self.id = submission.id
        self.title = submission.title
        self.meta = submission.meta
    }
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        let titleAttributes = NSMutableAttributedString(
            string: self.title,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold),
                NSForegroundColorAttributeName: ThemeManager.textPrimary()
            ])
        let footNoteAttributes = NSMutableAttributedString(
            string: self.meta,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightRegular),
                NSForegroundColorAttributeName: ThemeManager.textSecondary()
            ])
        let cell = CellNodeHeaderFootnote()
        cell.textNodeHeader.attributedText = titleAttributes
        cell.textNodeFootnote.attributedText = footNoteAttributes
        cell.inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.hasSeparator = true
        cell.separatorColor = ThemeManager.background()
        cell.backgroundColor = ThemeManager.cellBackground()
        return cell
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        delegate.didSelectDiscussion(discussion: self)
    }
}
