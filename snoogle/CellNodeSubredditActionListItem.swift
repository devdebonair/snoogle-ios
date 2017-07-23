//
//  CellNodeSubredditActionListItem.swift
//  snoogle
//
//  Created by Vincent Moore on 7/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeSubredditActionListItem: ASCellNode {
    
    let textNodeTitle = ASTextNode()
    let textNodeSubtitle = ASTextNode()
    let imageNode = ASNetworkImageNode()
    let imageHeight: CGFloat
    let buttonNode = ASButtonNode()
    
    init(title: String, subtitle: String, url: URL? = nil, imageHeight: CGFloat = 40) {
        self.imageHeight = imageHeight
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        textNodeTitle.isLayerBacked = true
        textNodeSubtitle.isLayerBacked = true
        imageNode.isLayerBacked = true
        
        textNodeTitle.maximumNumberOfLines = 1
        textNodeSubtitle.maximumNumberOfLines = 1
        
        imageNode.cornerRadius = imageHeight / 2
        imageNode.clipsToBounds = true
        imageNode.contentMode = .scaleAspectFill
        imageNode.placeholderEnabled = true
        imageNode.placeholderFadeDuration = 1.0
        
        let colorFloat: CGFloat = 170/255
        let textColor = UIColor(red: colorFloat, green: colorFloat, blue: colorFloat, alpha: 1.0)
        imageNode.placeholderColor = textColor
        
        self.textNodeTitle.attributedText = NSAttributedString(
            string: title,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                NSForegroundColorAttributeName: textColor
            ])
        
        self.textNodeSubtitle.attributedText = NSAttributedString(
            string: subtitle,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: textColor
            ])
        
        imageNode.url = url
        imageNode.cornerRadius = 6.0
        imageNode.clipsToBounds = true
        
        buttonNode.setImage(#imageLiteral(resourceName: "plus"), for: [])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: imageHeight, height: imageHeight)
        buttonNode.style.preferredSize = CGSize(width: 20, height: 20)
        
        let textStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 2,
            justifyContent: .start,
            alignItems: .start,
            children: [textNodeTitle, textNodeSubtitle])
        
        let layout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20,
            justifyContent: .start,
            alignItems: .center,
            children: [imageNode, textStack, buttonNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20), child: layout)
    }
    
}
