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
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        self.borderWidth = 0.6
        let colorValue: Float = 200/255
        self.borderColor = UIColor(colorLiteralRed: colorValue, green: colorValue, blue: colorValue, alpha: 1.0).cgColor
        self.cornerRadius = 5.0
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
        
        let media = CellNodeMedia(media: mediaItems)
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
