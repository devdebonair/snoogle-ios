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

class CellNodePostLink: CellNode {
    
    let textMeta: ASTextNode
    let textTitle: ASTextNode
    let textSubtitle: ASTextNode
    let separator: ASDisplayNode
    let actionBar: CellNodePostActionBar
    let media: MediaElement?
    
    var linkView: CellNodeLink
    var tagsView: NodeSlide? = nil
    var tagItems = [ViewModelElement]()
    
    init(meta: NSMutableAttributedString?, title: NSMutableAttributedString?, subtitle: NSMutableAttributedString?, media: MediaElement? = nil, vote: VoteType, saved: Bool, numberOfComments: Int = 0, linkTitle: NSMutableAttributedString, linkSubtitle: NSMutableAttributedString) {
        textMeta = ASTextNode()
        textTitle = ASTextNode()
        textSubtitle = ASTextNode()
        separator = ASDisplayNode()
        linkView = CellNodeLink(didLoad: nil)
        actionBar = CellNodePostActionBar(vote: vote, saved: saved, numberOfComments: numberOfComments)
        
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
        
        let separatorColor = UIColor(red: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
        separator.backgroundColor = separatorColor
    }
    
    override func didLoad() {
        super.didLoad()
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
//        guard let delegate = delegate else { return }
//        delegate.didTapLink()
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var contentLayoutElements = [ASLayoutElement]()
        contentLayoutElements.append(textMeta)
        contentLayoutElements.append(textTitle)
        
        if !tagItems.isEmpty {
            self.tagsView = NodeSlide(models: self.tagItems)
            if let layout = self.tagsView?.collectionNode.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset.right = 10.0
            }
            self.tagsView?.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20.0)
            if let tagsView = tagsView {
                contentLayoutElements.append(tagsView)
            }
        }
        
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
}
