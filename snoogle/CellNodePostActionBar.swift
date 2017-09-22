//
//  CellNodePostAction.swift
//  snoogle
//
//  Created by Vincent Moore on 5/15/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol CellNodePostActionBarDelegate {
    func didUpvote()
    func didDownvote()
    func didUnvote()
    func didSave()
    func didUnsave()
    func didTapComments()
}

class CellNodePostActionBar: CellNode {
    
    let colorUp = UIColor(red: 255/255, green: 69/255, blue: 0, alpha: 1.0)
    let colorDown = UIColor(red: 135/255, green: 135/255, blue: 1, alpha: 1.0)
    let colorSave = UIColor(red: 251/255, green: 195/255, blue: 51/255, alpha: 1.0)
    
    let buttonDiscussion: ASButtonNode
    let buttonSave: ASButtonNode
    let buttonUpVote: ASButtonNode
    let buttonDownVote: ASButtonNode
    
    var delegate: CellNodePostActionBarDelegate? = nil
    
    var vote: VoteType = .none {
        didSet {
            switch vote {
            case .up:
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                buttonUpVote.animate(image: #imageLiteral(resourceName: "up-arrow-filled"), color: colorUp)
                generator.notificationOccurred(.success)
                if let delegate = delegate {
                    delegate.didUpvote()
                }
            case .down:
                buttonDownVote.animate(image: #imageLiteral(resourceName: "down-arrow-filled"), color: colorDown)
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                if let delegate = delegate {
                    delegate.didDownvote()
                }
            case .none:
                buttonUpVote.setImage(#imageLiteral(resourceName: "up-arrow"), for: [])
                buttonDownVote.setImage(#imageLiteral(resourceName: "down-arrow"), for: [])
                buttonUpVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
                buttonDownVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
                if let delegate = delegate {
                    delegate.didUnvote()
                }
            }
        }
    }
    
    var isSaved: Bool = false {
        didSet {
            if isSaved {
                buttonSave.animate(image: #imageLiteral(resourceName: "star-filled"), color: colorSave)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                if let delegate = delegate {
                    delegate.didSave()
                }
            } else {
                buttonSave.setImage(#imageLiteral(resourceName: "star"), for: [])
                buttonSave.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
                if let delegate = delegate {
                    delegate.didUnsave()
                }
            }
        }
    }
    
    init(vote: VoteType = .none, saved: Bool = false, numberOfComments: Int = 0) {
        buttonDiscussion = ASButtonNode()
        buttonSave = ASButtonNode()
        buttonUpVote = ASButtonNode()
        buttonDownVote = ASButtonNode()
        
        super.init()
        
        self.vote = vote
        self.isSaved = saved
        
        automaticallyManagesSubnodes = true
        
        buttonUpVote.setImage(#imageLiteral(resourceName: "up-arrow"), for: [])
        buttonDownVote.setImage(#imageLiteral(resourceName: "down-arrow"), for: [])
        buttonSave.setImage(#imageLiteral(resourceName: "star"), for: [])
        
        buttonUpVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
        buttonDownVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
        buttonSave.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.black)
        
        if isSaved {
            buttonSave.setImage(#imageLiteral(resourceName: "star-filled"), for: [])
            buttonSave.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(colorSave)
        }
        
        switch vote {
        case .up:
            buttonUpVote.setImage(#imageLiteral(resourceName: "up-arrow-filled"), for: [])
            buttonUpVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(colorUp)
        case .down:
            buttonDownVote.setImage(#imageLiteral(resourceName: "down-arrow-filled"), for: [])
            buttonDownVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(colorDown)
        case .none:
            break
        }
        
        let commentFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        let commentColor = UIColor(red: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
        let discussionButtonAttributes = NSMutableAttributedString(
            string: "\(numberOfComments) Comments",
            attributes: [
                NSFontAttributeName: commentFont,
                NSForegroundColorAttributeName: commentColor
            ])
        buttonDiscussion.setImage(#imageLiteral(resourceName: "chat"), for: [])
        buttonDiscussion.setAttributedTitle(discussionButtonAttributes, for: [])
        
        buttonSave.imageNode.contentMode = .scaleAspectFit
        buttonUpVote.imageNode.contentMode = .scaleAspectFit
        buttonDownVote.imageNode.contentMode = .scaleAspectFit
        buttonDiscussion.imageNode.contentMode = .scaleAspectFit
        
        buttonUpVote.addTarget(self, action: #selector(self.upvote), forControlEvents: .touchUpInside)
        buttonDownVote.addTarget(self, action: #selector(self.downvote), forControlEvents: .touchUpInside)
        buttonSave.addTarget(self, action: #selector(self.saved), forControlEvents: .touchUpInside)
        buttonDiscussion.addTarget(self, action: #selector(self.tappedDiscussion), forControlEvents: .touchUpInside)
    }
    
    func upvote() {
        switch vote {
        case .none:
            vote = .up
        case .up:
            vote = .none
        case .down:
            vote = .none
            vote = .up
        }
    }
    
    func downvote() {
        switch vote {
        case .none:
            vote = .down
        case .up:
            vote = .none
            vote = .down
        case .down:
            vote = .none
        }
    }
    
    func saved() {
        isSaved = !isSaved
    }
    
    func tappedDiscussion() {
        guard let delegate = delegate else { return }
        delegate.didTapComments()
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let buttonSize: CGFloat = 16
        buttonSave.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonUpVote.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonDownVote.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonDiscussion.style.height = ASDimension(unit: .points, value: buttonSize)
        
        let stackLayoutButton = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 15.0,
            justifyContent: .end,
            alignItems: .center,
            children: [
                buttonSave,
                buttonDownVote,
                buttonUpVote
            ])
        
        let stackLayoutButtonContainer = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0.0,
            justifyContent: .start,
            alignItems: .center,
            children: [
                buttonDiscussion,
                stackLayoutButton
            ])
        
        stackLayoutButton.style.flexGrow = 1.0
        stackLayoutButtonContainer.style.width = ASDimension(unit: .points, value: constrainedSize.max.width)
        
        return stackLayoutButtonContainer
    }
    
}
