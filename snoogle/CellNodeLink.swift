//
//  CellNodeLink.swift
//  snoogle
//
//  Created by Vincent Moore on 7/12/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodeLink: CellNode {
    
    var preview: MediaElement?
    var textTitle = ASTextNode()
    let textSubtitle = ASTextNode()
    var media = ASDisplayNode()
    
    override init(didLoad: ((CellNode)->Void)? = nil){
        super.init(didLoad: didLoad)
        self.selectionStyle = .gray
    }
    
    override func didLoad() {
        super.didLoad()
        self.borderWidth = 0.6
        let colorValue: CGFloat = 220/255
        self.borderColor = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 1.0).cgColor
        
        self.shadowOffset = CGSize(width: 0, height: 1.0)
        self.backgroundColor = .white
        self.clipsToBounds = false
        self.shadowOpacity = 0.10
        self.shadowRadius = 1.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        textTitle.maximumNumberOfLines = 3
        
        textTitle.style.width = ASDimension(unit: .points, value: 250)
        
        var mediaItems: [MediaElement] = []
        if let preview = preview {
            mediaItems.append(preview)
        }
        
        if let preview = preview {
            media = CellNodeMedia(media: preview)
        } else {
            media = ASDisplayNode()
        }
        
        if let media = media as? CellNodeMedia {
            media.mediaView.cropRect = CGRect(x: 0.5, y: 0, width: 0, height: 0)
        }
        
        media.style.width = ASDimension(unit: .points, value: 100.0)
        media.style.height = ASDimension(unit: .points, value: 120.0)
        
        let stackTextInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let stackText = ASStackLayoutSpec(direction: .vertical, spacing: 10.0, justifyContent: .start, alignItems: .start, children: [textTitle, textSubtitle])
        let stackTextWithInset = ASInsetLayoutSpec(insets: stackTextInset, child: stackText)
        
        let stackContainer = ASStackLayoutSpec(direction: .horizontal, spacing: 0.0, justifyContent: .start, alignItems: .start, children: [media, stackTextWithInset])
        stackContainer.style.width = ASDimension(unit: .fraction, value: 1.0)
        
        return stackContainer
    }
}
