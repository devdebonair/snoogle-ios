//
//  CellNodePostAction.swift
//  snoogle
//
//  Created by Vincent Moore on 9/28/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol CellNodePostActionDelegate {
    func didUpvote()
    func didDownvote()
    func didUnvote()
    func didSave()
    func didUnsave()
    func didComment()
}

class CellNodePostAction: CellNode {
    let stateSaveDisabled: CellNodeButtonState.State
    let stateSaveEnabled: CellNodeButtonState.State
    let stateComment: CellNodeButtonState.State
    let stateUpvote: CellNodeButtonState.State
    let stateDownvote: CellNodeButtonState.State
    let stateUnvote: CellNodeButtonState.State
    
    let buttonSave: CellNodeButtonState
    let buttonVote: CellNodeButtonState
    let buttonComment: CellNodeButtonState
    
    var delegate: CellNodePostActionDelegate? = nil
    
    enum PostAction: String {
        case save = "save"
        case unsave = "unsave"
        case upvote = "upvote"
        case downvote = "downvote"
        case unvote = "unvote"
        case comment = "comment"
    }
    
    init() {
        let textSaveDisabled = NSMutableAttributedString(string: "Save", attributes: [
            NSForegroundColorAttributeName: UIColor.flatGrayDark,
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        ])
        let textSaveEnabled = NSMutableAttributedString(string: "Saved", attributes: [
            NSForegroundColorAttributeName: UIColor.flatYellow,
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
            ])
        let textComment = NSMutableAttributedString(string: "Comment", attributes: [
            NSForegroundColorAttributeName: UIColor.flatGrayDark,
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
            ])
        let textUnvote = NSMutableAttributedString(string: "Upvote", attributes: [
            NSForegroundColorAttributeName: UIColor.flatGrayDark,
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
            ])
        let textUpvote = NSMutableAttributedString(string: "Upvoted", attributes: [
            NSForegroundColorAttributeName: UIColor.flatRed,
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
            ])
        let textDownvote = NSMutableAttributedString(string: "Downvoted", attributes: [
            NSForegroundColorAttributeName: UIColor.flatPurple,
            NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
            ])
        self.stateSaveDisabled = CellNodeButtonState.State(key: PostAction.unsave.rawValue, color: .flatGrayDark, image: #imageLiteral(resourceName: "star-filled"), text: textSaveDisabled)
        self.stateSaveEnabled = CellNodeButtonState.State(key: PostAction.save.rawValue, color: .flatYellow, image: #imageLiteral(resourceName: "star-filled"), text: textSaveEnabled)
        self.stateComment = CellNodeButtonState.State(key: PostAction.comment.rawValue, color: .flatGrayDark, image: #imageLiteral(resourceName: "chat-filled"), text: textComment)
        self.stateUpvote = CellNodeButtonState.State(key: PostAction.upvote.rawValue, color: .flatRed, image: #imageLiteral(resourceName: "up-arrow-filled"), text: textUpvote)
        self.stateDownvote = CellNodeButtonState.State(key: PostAction.downvote.rawValue, color: .flatPurple, image: #imageLiteral(resourceName: "down-arrow-filled"), text: textDownvote)
        self.stateUnvote = CellNodeButtonState.State(key: PostAction.unvote.rawValue, color: .flatGrayDark, image: #imageLiteral(resourceName: "up-arrow-filled"), text: textUnvote)
        self.buttonSave = CellNodeButtonState()
        self.buttonVote = CellNodeButtonState()
        self.buttonComment = CellNodeButtonState()
        super.init(didLoad: nil)
        self.buttonSave.delegate = self
        self.buttonVote.delegate = self
        self.buttonComment.delegate = self
    }
    
    override func willBuildLayout(constrainedSize: ASSizeRange) {
        self.buttonComment.states = [stateComment]
        self.buttonSave.states = [stateSaveDisabled, stateSaveEnabled]
        self.buttonVote.states = [stateUnvote, stateUpvote, stateDownvote]
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let buttonSize: CGFloat = 16
        self.buttonSave.style.height = ASDimension(unit: .points, value: buttonSize)
        self.buttonVote.style.height = ASDimension(unit: .points, value: buttonSize)
        self.buttonComment.style.height = ASDimension(unit: .points, value: buttonSize)
        
        self.buttonComment.style.width = ASDimension(unit: .fraction, value: (1/3))
        self.buttonSave.style.width = ASDimension(unit: .fraction, value: (1/3))
        self.buttonVote.style.width = ASDimension(unit: .fraction, value: (1/3))
        
        let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [self.buttonComment, self.buttonSave, self.buttonVote])
        stack.style.flexGrow = 1.0
        stack.style.width = ASDimension(unit: .points, value: constrainedSize.max.width)
        return stack
    }
}

extension CellNodePostAction: CellNodeButtonStateDelegate {
    func didChangeState(state: CellNodeButtonState.State) {
        guard let action = PostAction(rawValue: state.key) else { return }
        switch action {
        case .comment:
            break
        case .save:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .unsave:
            break
        case .upvote:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .downvote:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .unvote:
            break
        }
        
        guard let delegate = delegate else { return }
        
        switch action {
        case .comment:
            delegate.didComment()
        case .save:
            delegate.didSave()
        case .unsave:
            delegate.didUnsave()
        case .upvote:
            delegate.didUpvote()
        case .downvote:
            delegate.didDownvote()
        case .unvote:
            delegate.didUnvote()
        }
    }
}
