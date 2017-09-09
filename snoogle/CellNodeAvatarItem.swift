//
//  CellNodeAvatarItem.swift
//  snoogle
//
//  Created by Vincent Moore on 6/1/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeAvatarItem: CellNode {
    
    let textNodeTitle = ASTextNode()
    let textNodeSubtitle = ASTextNode()
    let imageNode = ASNetworkImageNode()
    let imageHeight: CGFloat
    
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
        imageNode.borderColor = UIColor.lightGray.cgColor
        imageNode.borderWidth = 1.0
        imageNode.clipsToBounds = true
        imageNode.contentMode = .scaleAspectFill
        
        self.textNodeTitle.attributedText = NSAttributedString(
            string: title,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
            ])
        
        self.textNodeSubtitle.attributedText = NSAttributedString(
            string: subtitle,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular),
                NSForegroundColorAttributeName: UIColor.lightGray
            ])
        
        imageNode.url = url
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: imageHeight, height: imageHeight)
        
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
            children: [imageNode, textStack])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20), child: layout)
    }
}
