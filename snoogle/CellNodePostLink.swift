//
//  CellNodePostLink.swift
//  snoogle
//
//  Created by Vincent Moore on 7/13/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class CellNodePostLink: ASCellNode, CellNodePostActionBarDelegate {
    let textMeta: ASTextNode
    let textTitle: ASTextNode
    let textSubtitle: ASTextNode
    let separator: ASDisplayNode
    let actionBar: CellNodePostActionBar
    
    var linkView: CellNodeLink
    
    let media: MediaElement?
    
    var delegate: CellNodePostDelegate? = nil
    
    init(meta: NSMutableAttributedString?, title: NSMutableAttributedString?, subtitle: NSMutableAttributedString?, media: MediaElement? = nil, vote: VoteType, saved: Bool, numberOfComments: Int = 0, linkTitle: NSMutableAttributedString, linkSubtitle: NSMutableAttributedString) {
        textMeta = ASTextNode()
        textTitle = ASTextNode()
        textSubtitle = ASTextNode()
        separator = ASDisplayNode()
        linkView = CellNodeLink(preview: media, title: linkTitle, subtitle: linkSubtitle)
        actionBar = CellNodePostActionBar(vote: vote, saved: saved, numberOfComments: numberOfComments)
        
        self.media = media
        
        super.init()
        
        textMeta.isLayerBacked = true
        textTitle.isLayerBacked = true
        textSubtitle.isLayerBacked = true
        separator.isLayerBacked = true
        
        actionBar.delegate = self
        
        automaticallyManagesSubnodes = true
        
        textMeta.attributedText = meta
        textTitle.attributedText = title
        textSubtitle.attributedText = subtitle
        
        let truncationText = subtitle
        truncationText?.mutableString.setString(" ... more")
        textSubtitle.truncationAttributedText = truncationText
        textSubtitle.maximumNumberOfLines = 5
        
        let separatorColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
        separator.backgroundColor = separatorColor
    }
    
    override func didLoad() {
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backgroundColor = .white
        self.clipsToBounds = false
        self.shadowOpacity = 0.20
        self.shadowRadius = 1.0
        self.cornerRadius = 2.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        self.linkView.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLink)))
    }
    
    func didTapLink(gesture: UITapGestureRecognizer) {
        guard let delegate = delegate else { return }
        delegate.didTapLink()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var contentLayoutElements = [ASLayoutElement]()
        contentLayoutElements.append(textMeta)
        contentLayoutElements.append(textTitle)
        
        let linkInset = UIEdgeInsets(top: 5.0, left: 0, bottom: 5.0, right: 0)
        let linkWithInset = ASInsetLayoutSpec(insets: linkInset, child: linkView)
        contentLayoutElements.append(linkWithInset)
        
        if let subtitleText = textSubtitle.attributedText, !subtitleText.string.isEmpty {
            contentLayoutElements.append(textSubtitle)
        }
        
        let stackLayoutContent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10.0,
            justifyContent: .start,
            alignItems: .start,
            children: contentLayoutElements)
        
        separator.style.width = ASDimension(unit: .fraction, value: 1.0)
        separator.style.height = ASDimension(unit: .points, value: 1.0)
        
        let padding: CGFloat = 20.0
        
        let inset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        let buttonInset = UIEdgeInsets(top: 14, left: padding, bottom: 14, right: padding)
        
        let insetContentLayout = ASInsetLayoutSpec(insets: inset, child: stackLayoutContent)
        let insetButtonLayout = ASInsetLayoutSpec(insets: buttonInset, child: actionBar)
        
        var stackContainerElements = [ASLayoutElement]()
        stackContainerElements.append(insetContentLayout)
        
        stackContainerElements.append(separator)
        stackContainerElements.append(insetButtonLayout)
        
        let stackContainer = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            children: stackContainerElements)
        
        return stackContainer
    }
    
    func didSave() {
        guard let delegate = delegate else { return }
        delegate.didSave()
    }
    
    func didUnsave() {
        guard let delegate = delegate else { return }
        delegate.didUnsave()
    }
    
    func didUnvote() {
        guard let delegate = delegate else { return }
        delegate.didUnvote()
    }
    
    func didUpvote() {
        guard let delegate = delegate else { return }
        delegate.didUpvote()
    }
    
    func didDownvote() {
        guard let delegate = delegate else { return }
        delegate.didDownvote()
    }
}
