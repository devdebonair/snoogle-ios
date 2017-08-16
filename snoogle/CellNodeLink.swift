//
//  CellNodeLink.swift
//  snoogle
//
//  Created by Vincent Moore on 7/12/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeLink: ASCellNode {
    
    let preview: MediaElement?
    let title: NSMutableAttributedString?
    let subtitle: NSMutableAttributedString?
    
    var inset: UIEdgeInsets = .zero
    
    init(preview: MediaElement? = nil, title: NSMutableAttributedString? = nil, subtitle: NSMutableAttributedString? = nil){
        self.preview = preview
        self.title = title
        self.subtitle = subtitle
        
        super.init()
        
        self.selectionStyle = .gray
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        self.borderWidth = 0.6
        let colorValue: Float = 220/255
        self.borderColor = UIColor(colorLiteralRed: colorValue, green: colorValue, blue: colorValue, alpha: 1.0).cgColor
        
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backgroundColor = .white
        self.clipsToBounds = false
        self.shadowOpacity = 0.20
        self.shadowRadius = 1.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textTitle = ASTextNode()
        let textSubtitle = ASTextNode()
        
        textTitle.attributedText = title
        textTitle.maximumNumberOfLines = 3
        textSubtitle.attributedText = subtitle
        
        textTitle.style.width = ASDimension(unit: .points, value: 250)
        
        var mediaItems: [MediaElement] = []
        if let preview = preview {
            mediaItems.append(preview)
        }
        
        let media: ASDisplayNode
        if let preview = preview {
            media = CellNodeMedia(media: preview)
        } else {
            media = ASDisplayNode()
        }

        media.style.width = ASDimension(unit: .points, value: 100.0)
        media.style.height = ASDimension(unit: .points, value: 120.0)
        
        let stackTextInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let stackText = ASStackLayoutSpec(direction: .vertical, spacing: 10.0, justifyContent: .start, alignItems: .start, children: [textTitle, textSubtitle])
        let stackTextWithInset = ASInsetLayoutSpec(insets: stackTextInset, child: stackText)
        
        let stackContainer = ASStackLayoutSpec(direction: .horizontal, spacing: 0.0, justifyContent: .start, alignItems: .start, children: [media, stackTextWithInset])
        stackContainer.style.width = ASDimension(unit: .fraction, value: 1.0)
        
        return ASInsetLayoutSpec(insets: inset, child: stackContainer)
    }
    
}
