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

class CellNodeDetail: ASCellNode {
    let textMeta: ASTextNode
    let textTitle: ASTextNode
    let textSubtitle: ASTextNode
    let separator: ASDisplayNode
    
    let buttonDiscussion: ASButtonNode
    let buttonSave: ASButtonNode
    let buttonUpVote: ASButtonNode
    let buttonDownVote: ASButtonNode
    
    var mediaView: ASImageNode? = nil
    
    let media: MediaElement?
    
    init(meta: NSMutableAttributedString?, title: NSMutableAttributedString?, subtitle: NSMutableAttributedString?, buttonAttributes: [String:Any?], media: MediaElement? = nil) {
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
        buttonDiscussion.setImage(#imageLiteral(resourceName: "talk"), for: [])
        
        buttonDiscussion.setAttributedTitle(NSAttributedString(string: "View Discussion", attributes: buttonAttributes), for: [])
        
        let separatorColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
        
        buttonSave.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(separatorColor)
        buttonUpVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(separatorColor)
        buttonDownVote.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(separatorColor)
        
        buttonSave.contentMode = .scaleAspectFit
        buttonUpVote.contentMode = .scaleAspectFit
        buttonDownVote.contentMode = .scaleAspectFit
        
        separator.backgroundColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
        
        if let media = media as? Photo {
            if let _ = media.urlSmall, let _ = media.urlMedium, let _ = media.urlLarge {
                mediaView = ASMultiplexImageNode()
                if let mediaView = mediaView as? ASMultiplexImageNode {
                    mediaView.imageIdentifiers = ["large" as NSCopying & NSObjectProtocol, "medium" as NSCopying & NSObjectProtocol, "small" as NSCopying & NSObjectProtocol]
                    mediaView.downloadsIntermediateImages = true
                    mediaView.dataSource = self
                    mediaView.isLayerBacked = true
                }
            } else {
                mediaView = ASNetworkImageNode()
                if let mediaView = mediaView as? ASNetworkImageNode {
                    mediaView.url = media.url
                    mediaView.contentMode = .scaleAspectFill
                    mediaView.isLayerBacked = true
                }
            }
        }
        
        if let media = media as? Video {
            mediaView = ASVideoNode()
            if let mediaView = mediaView as? ASVideoNode {
                mediaView.url = media.poster
                mediaView.gravity = AVLayerVideoGravityResizeAspectFill
                mediaView.shouldAutoplay = true
                mediaView.shouldAutorepeat = true
                mediaView.placeholderEnabled = true
                mediaView.placeholderFadeDuration = 2.0
                mediaView.backgroundColor = .black
                mediaView.muted = true
                mediaView.isLayerBacked = true
            }
        }
    }
    
    override func didLoad() {
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backgroundColor = .white
        self.clipsToBounds = false
        self.shadowOpacity = 0.30
        self.shadowRadius = 1.0
        self.cornerRadius = 2.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
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
        
        let stackLayoutButton = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 30.0,
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
        let buttonInset = UIEdgeInsets(top: 15, left: padding, bottom: 15, right: padding)
        
        let insetContentLayout = ASInsetLayoutSpec(insets: inset, child: stackLayoutContent)
        let insetButtonLayout = ASInsetLayoutSpec(insets: buttonInset, child: stackLayoutButtonContainer)

        var stackContainerElements = [ASLayoutElement]()
        stackContainerElements.append(insetContentLayout)

        if let media = media, let mediaView = mediaView {
            let ratio = CGFloat(media.height/media.width)
            let ratioSpec = ASRatioLayoutSpec(ratio: ratio, child: mediaView)
            stackContainerElements.append(ratioSpec)
            
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
    
    override func didEnterVisibleState() {
        if let media = media as? Video, let mediaView = mediaView as? ASVideoNode {
            DispatchQueue.global(qos: .background).async {
                if let url = media.url {
                    let asset = AVAsset(url: url)
                    DispatchQueue.main.async {
                        mediaView.asset = asset
                    }
                }
            }
        }
    }
}

extension CellNodeDetail: ASMultiplexImageNodeDataSource {
    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, urlForImageIdentifier imageIdentifier: ASImageIdentifier) -> URL? {
        guard let media = media as? Photo, let imageIdentifier = imageIdentifier as? String else { return nil }
        switch imageIdentifier {
        case "small":
            return media.urlSmall
        case "medium":
            return media.urlMedium
        case "large":
            return media.urlLarge
        default:
            return nil
        }
    }
}
