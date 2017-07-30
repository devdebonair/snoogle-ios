//
//  CellNodeSubredditListItem.swift
//  snoogle
//
//  Created by Vincent Moore on 6/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeSubredditListItem: CellNode {
    
    let textNodeTitle = ASTextNode()
    let textNodeSubtitle = ASTextNode()
    let imageNode = ASNetworkImageNode()
    let imageHeight: CGFloat
    
    init(title: NSMutableAttributedString, subtitle: NSMutableAttributedString, url: URL? = nil, imageHeight: CGFloat = 40) {
        self.imageHeight = imageHeight
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        textNodeTitle.isLayerBacked = true
        textNodeSubtitle.isLayerBacked = true
        imageNode.isLayerBacked = true
        
        textNodeTitle.maximumNumberOfLines = 1
        textNodeSubtitle.maximumNumberOfLines = 2
        
        imageNode.cornerRadius = imageHeight / 2
        imageNode.clipsToBounds = true
        imageNode.contentMode = .scaleAspectFill
        imageNode.placeholderEnabled = true
        imageNode.placeholderFadeDuration = 1.0
        
        let colorFloat: CGFloat = 170/255
        let textColor = UIColor(red: colorFloat, green: colorFloat, blue: colorFloat, alpha: 1.0)
        imageNode.placeholderColor = textColor
        
        self.textNodeTitle.attributedText = title
        self.textNodeSubtitle.attributedText = subtitle
        
        imageNode.url = url
        imageNode.cornerRadius = 6.0
        imageNode.clipsToBounds = true
        
        self.inset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: imageHeight, height: imageHeight)
        
        let textStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 4,
            justifyContent: .start,
            alignItems: .start,
            children: [textNodeTitle, textNodeSubtitle])
        
        let layout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 15,
            justifyContent: .start,
            alignItems: .center,
            children: [imageNode, textStack])
        
        textStack.style.flexShrink = 1.0
        
        return layout
    }
}
