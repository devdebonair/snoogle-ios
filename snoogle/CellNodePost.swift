//
//  CellNodeDetail.swift
//  snoogle
//
//  Created by Vincent Moore on 12/26/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

protocol CellNodePostDelegate {
    func didUpvote()
    func didDownvote()
    func didUnvote()
    func didSave()
    func didUnsave()
    func didTapLink()
    func didTapComments()
    func didTapMedia(index: Int)
}

class CellNodePost: ASCellNode, CellNodePostActionBarDelegate, CellNodeMediaDelegate {
    let media: [MediaElement]?
    
    let textMeta: ASTextNode
    let textTitle: ASTextNode
    let textSubtitle: ASTextNode
    let separator: ASDisplayNode
    let actionBar: CellNodePostActionBar
    
    var mediaView: ASDisplayNode? = nil
    var delegate: CellNodePostDelegate? = nil
    
    init(meta: NSMutableAttributedString?, title: NSMutableAttributedString?, subtitle: NSMutableAttributedString?, media: [MediaElement], vote: VoteType, saved: Bool, numberOfComments: Int = 0) {
        textMeta = ASTextNode()
        textTitle = ASTextNode()
        textSubtitle = ASTextNode()
        separator = ASDisplayNode()
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
        
        if !media.isEmpty {
            mediaView = CellNodeMediaAlbum(media: media)
        }
        
        if let mediaView = mediaView as? CellNodeMediaAlbum {
            mediaView.delegate = self
        }
    }
    
    func didTapMedia(selectedIndex: Int) {
        guard let delegate = delegate else { return }
        delegate.didTapMedia(index: selectedIndex)
    }
    
    override func didLoad() {
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backgroundColor = .white
        self.clipsToBounds = false
        self.shadowOpacity = 0.20
        self.shadowRadius = 1.0
        self.cornerRadius = 2.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        if let media = media, media.count == 1, let mediaView = mediaView as? CellNodeMediaAlbum {
            mediaView.collectionNode.view.bounces = false
            mediaView.collectionNode.view.isScrollEnabled = false
            mediaView.collectionNode.clipsToBounds = true
        }
        
        if let media = media, media.count > 1, let mediaView = mediaView as? CellNodeMediaAlbum {
            mediaView.flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            mediaView.flowLayout.minimumLineSpacing = 15.0
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var contentLayoutElements = [ASLayoutElement]()
        contentLayoutElements.append(textMeta)
        contentLayoutElements.append(textTitle)
        
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

        if let mediaView = mediaView as? CellNodeMediaAlbum, let media = media {
            if media.count == 1 {
                stackContainerElements.append(mediaView)
            } else if media.count > 1 {
                let inset = UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)
                let insetMediaLayout = ASInsetLayoutSpec(insets: inset, child: mediaView)
                stackContainerElements.append(insetMediaLayout)
            }
            
            if let subtitleText = textSubtitle.attributedText, !subtitleText.string.isEmpty {
                if let contentChildren = stackLayoutContent.children, contentChildren.count > 2 {
                    let _ = stackLayoutContent.children?.popLast()
                    let subtitleInset = UIEdgeInsets(top: 20, left: padding, bottom: 20, right: padding)
                    let subtitleInsetLayout = ASInsetLayoutSpec(insets: subtitleInset, child: textSubtitle)
                    stackContainerElements.append(subtitleInsetLayout)
                }
            }
        }
        
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
    
    func didTapComments() {
        guard let delegate = delegate else { return }
        delegate.didTapComments()
    }
}
