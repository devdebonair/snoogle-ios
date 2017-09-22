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
                NSForegroundColorAttributeName: UIColor.darkText
            ])
        let footNoteAttributes = NSMutableAttributedString(
            string: self.meta,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightRegular),
                NSForegroundColorAttributeName: UIColor.lightGray
            ])
        let cell = CellNodeHeaderFootnote()
        cell.textNodeHeader.attributedText = titleAttributes
        cell.textNodeFootnote.attributedText = footNoteAttributes
        cell.inset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cell.hasSeparator = true
        let colorValue: CGFloat = 240/255
        cell.separatorColor = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 1.0)
        cell.backgroundColor = .white
        return cell
    }
    
    func didSelect(index: Int) {
        guard let delegate = delegate else { return }
        delegate.didSelectDiscussion(discussion: self)
    }
}
