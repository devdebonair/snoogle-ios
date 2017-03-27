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

class CellNodePost: ASCellNode {
    let textMeta: ASTextNode
    let textTitle: ASTextNode
    let textSubtitle: ASTextNode
    let separator: ASDisplayNode
    
    let buttonDiscussion: ASButtonNode
    let buttonSave: ASButtonNode
    let buttonUpVote: ASButtonNode
    let buttonDownVote: ASButtonNode
    
    var mediaView: ASDisplayNode? = nil
    
    let media: [MediaElement]?
    
    init(meta: NSMutableAttributedString?, title: NSMutableAttributedString?, subtitle: NSMutableAttributedString?, leftbuttonAttributes: NSMutableAttributedString, media: [MediaElement]) {
        textMeta = ASTextNode()
        textTitle = ASTextNode()
        textSubtitle = ASTextNode()
        separator = ASDisplayNode()
        buttonDiscussion = ASButtonNode()
        buttonSave = ASButtonNode()
        buttonUpVote = ASButtonNode()
        buttonDownVote = ASButtonNode()
        
        self.media = media
        
        super.init()
        
        textMeta.isLayerBacked = true
        textTitle.isLayerBacked = true
        textSubtitle.isLayerBacked = true
        separator.isLayerBacked = true
        
        automaticallyManagesSubnodes = true
        
        textMeta.attributedText = meta
        textTitle.attributedText = title
        textSubtitle.attributedText = subtitle
        
        let truncationText = subtitle
        truncationText?.mutableString.setString(" ... more")
        textSubtitle.truncationAttributedText = truncationText
        
        textSubtitle.maximumNumberOfLines = 5

        buttonSave.setImage(#imageLiteral(resourceName: "star"), for: [])
        buttonUpVote.setImage(#imageLiteral(resourceName: "up-arrow"), for: [])
        buttonDownVote.setImage(#imageLiteral(resourceName: "down-arrow"), for: [])
        buttonDiscussion.setImage(#imageLiteral(resourceName: "chat"), for: [])
        
        buttonDiscussion.setAttributedTitle(leftbuttonAttributes, for: [])
        
        let separatorColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
        
        buttonSave.imageNode.contentMode = .scaleAspectFit
        buttonUpVote.imageNode.contentMode = .scaleAspectFit
        buttonDownVote.imageNode.contentMode = .scaleAspectFit
        buttonDiscussion.imageNode.contentMode = .scaleAspectFit
        
        separator.backgroundColor = separatorColor
        
        if media.count == 1 {
            mediaView = NodeMedia(media: media[0])
        }
        if media.count > 1 {
            mediaView = NodeMediaAlbum(media: media)
        }
    }
    
    override func didLoad() {
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backgroundColor = .white
        self.clipsToBounds = false
        self.shadowOpacity = 0.20
        self.shadowRadius = 1.0
        self.cornerRadius = 2.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var contentLayoutElements = [ASLayoutElement]()
        contentLayoutElements.append(textMeta)
        contentLayoutElements.append(textTitle)

        let buttonSize: CGFloat = 18
        buttonSave.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonUpVote.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonDownVote.style.height = ASDimension(unit: .points, value: buttonSize)
        buttonDiscussion.style.height = ASDimension(unit: .points, value: buttonSize)
        
        if let subtitleText = textSubtitle.attributedText, !subtitleText.string.isEmpty {
            contentLayoutElements.append(textSubtitle)
        }
        
        let stackLayoutContent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10.0,
            justifyContent: .start,
            alignItems: .start,
            children: contentLayoutElements)
        
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
        
        separator.style.width = ASDimension(unit: .fraction, value: 1.0)
        separator.style.height = ASDimension(unit: .points, value: 1.0)
        
        let padding: CGFloat = 20.0
        
        let inset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        let buttonInset = UIEdgeInsets(top: 14, left: padding, bottom: 14, right: padding)
        
        let insetContentLayout = ASInsetLayoutSpec(insets: inset, child: stackLayoutContent)
        let insetButtonLayout = ASInsetLayoutSpec(insets: buttonInset, child: stackLayoutButtonContainer)

        var stackContainerElements = [ASLayoutElement]()
        stackContainerElements.append(insetContentLayout)

        if let mediaView = mediaView {
            
            if let mediaView = mediaView as? NodeMedia {
                stackContainerElements.append(mediaView)
            }
            
            if let mediaView = mediaView as? NodeMediaAlbum {
                mediaView.style.width = ASDimension(unit: .fraction, value: 1.0)
                mediaView.style.height = ASDimension(unit: .points, value: 150)
                mediaView.collectionNode.clipsToBounds = false
                let inset = UIEdgeInsets(top: 0, left: padding, bottom: padding, right: 0)
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
}
