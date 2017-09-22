//
//  CellNodeMenuItem.swift
//  snoogle
//
//  Created by Vincent Moore on 5/29/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeMenuItem: ASCellNode {
    let imageIcon = ASImageNode()
    let textTitle = ASTextNode()
    
    init(image: UIImage, title: String) {
        imageIcon.image = image
        textTitle.attributedText = NSAttributedString(string: title)
        
        let font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        let color = UIColor(red: 50/255, green: 48/255, blue: 48/255, alpha: 1.0)
        let attributes = NSMutableAttributedString(
            string: title,
            attributes: [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color
            ])
        textTitle.attributedText = attributes
        imageIcon.contentMode = .scaleAspectFit
        
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let size: CGFloat = 25
        imageIcon.style.preferredSize = CGSize(width: size, height: size)
        let stackContainer = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20.0,
            justifyContent: .start,
            alignItems: .center,
            children: [imageIcon, textTitle])
        let inset: CGFloat = 20
        let insetEdge = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return ASInsetLayoutSpec(insets: insetEdge, child: stackContainer)
    }
}
