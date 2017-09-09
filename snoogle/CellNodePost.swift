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

class CellNodePost: CellNode {
    var INSET_PADDING: CGFloat = 20.0
    
    var media = [MediaElement]()
    
    let textMeta: ASTextNode
    let textTitle: ASTextNode
    let textSubtitle: ASTextNode
    let separator: ASDisplayNode
    let actionBar: CellNodePostActionBar
    
    var tagItems = [TagViewModel]()
    
    var mediaView: CellNodeMediaAlbum? = nil
    var tagsView: CellNodeTagsSlide? = nil
    
    private var attachments = [ASLayoutElement]()
    
    init(meta: NSMutableAttributedString?, title: NSMutableAttributedString?, subtitle: NSMutableAttributedString?, media: [MediaElement], vote: VoteType, saved: Bool, numberOfComments: Int = 0) {
        textMeta = ASTextNode()
        textTitle = ASTextNode()
        textSubtitle = ASTextNode()
        separator = ASDisplayNode()
        actionBar = CellNodePostActionBar(vote: vote, saved: saved, numberOfComments: numberOfComments)
        
        super.init()
        
        textMeta.isLayerBacked = true
        textTitle.isLayerBacked = true
        textSubtitle.isLayerBacked = true
        separator.isLayerBacked = true
        
        separator.backgroundColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
    }
    
    override func willBuildLayout(constrainedSize: ASSizeRange) {
        self.tagsView = self.tagItems.isEmpty ? nil : CellNodeTagsSlide(tags: tagItems)
    }
    
    override func didLoad() {
        super.didLoad()
        self.backgroundColor = .white
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.clipsToBounds = false
        self.shadowOpacity = 0.20
        self.shadowRadius = 1.0
        self.cornerRadius = 2.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        if media.count == 1, let mediaView = mediaView {
            mediaView.collectionNode.view.bounces = false
            mediaView.collectionNode.view.isScrollEnabled = false
            mediaView.collectionNode.clipsToBounds = true
        }
        
        if media.count > 1, let mediaView = mediaView {
            mediaView.flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            mediaView.flowLayout.minimumLineSpacing = 15.0
        }
    }
    
    func add(attachments: [ASLayoutElement]) {
        self.attachments.append(contentsOf: attachments)
    }
    
    func add(attachment: ASLayoutElement) {
        self.add(attachments: [attachment])
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var contentLayoutElements = [ASLayoutElement]()
        
        let insetForNoneAttachments = UIEdgeInsets(top: 0, left: INSET_PADDING, bottom: 0, right: INSET_PADDING)
        let insetForNoneAttachmentsFullWidth = UIEdgeInsets(top: 0, left: INSET_PADDING, bottom: 0, right: 0)
        
        let insetLayoutTextMeta = ASInsetLayoutSpec(insets: insetForNoneAttachments, child: textMeta)
        let insetLayoutTextTitle = ASInsetLayoutSpec(insets: insetForNoneAttachments, child: textTitle)

        contentLayoutElements.append(insetLayoutTextMeta)
        contentLayoutElements.append(insetLayoutTextTitle)
        
        if let tagsView = tagsView {
            tagsView.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20.0)
            let insetLayoutTagsView = ASInsetLayoutSpec(insets: insetForNoneAttachmentsFullWidth, child: tagsView)
            contentLayoutElements.append(insetLayoutTagsView)
        }
        
        contentLayoutElements.append(contentsOf: attachments)
        
        let stackElements = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: contentLayoutElements)
        let insetForStackElements = UIEdgeInsets(top: INSET_PADDING, left: 0, bottom: 0, right: 0)
        let insetLayoutStackElements = ASInsetLayoutSpec(insets: insetForStackElements, child: stackElements)
        
        separator.style.width = ASDimension(unit: .fraction, value: 1.0)
        separator.style.height = ASDimension(unit: .points, value: 1.0)
        
        let actionBarInset = UIEdgeInsets(top: 14, left: INSET_PADDING, bottom: 14, right: INSET_PADDING)
        let insetLayoutForActionBar = ASInsetLayoutSpec(insets: actionBarInset, child: actionBar)
        
        let stackContainer = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .start,
            alignItems: .start,
            children: [])
        
        stackContainer.children?.append(insetLayoutStackElements)
        
        var hasSubtitle = false
        if let subtitleText = textSubtitle.attributedText, !subtitleText.string.isEmpty {
            hasSubtitle = true
            let topPadding: CGFloat = attachments.isEmpty ? stackElements.spacing : INSET_PADDING
            let insetForSubtitle = UIEdgeInsets(top: topPadding, left: INSET_PADDING, bottom: INSET_PADDING, right: INSET_PADDING)
            let insetLayoutTextSubtitle = ASInsetLayoutSpec(insets: insetForSubtitle, child: textSubtitle)
            stackContainer.children?.append(insetLayoutTextSubtitle)
        }
        
        stackContainer.children?.append(separator)
        stackContainer.children?.append(insetLayoutForActionBar)
        
        if !hasSubtitle && attachments.isEmpty {
            insetLayoutStackElements.insets.bottom = self.INSET_PADDING
        }
        
        return stackContainer
    }
}
