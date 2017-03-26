////
////  CellNodePhoto.swift
////  snoogle
////
////  Created by Vincent Moore on 12/28/16.
////  Copyright © 2016 Vincent Moore. All rights reserved.
////
//
//import Foundation
//import UIKit
//import AsyncDisplayKit
//
//class CellNodeMedia: ASCellNode {
//    
//    let media: [MediaElement]
//    var mediaView: ASDisplayNode!
//    let inset: UIEdgeInsets
//    
//    init(media: [MediaElement], inset: UIEdgeInsets = .zero) {
//        self.media = media
//        self.inset = inset
//        
//        super.init()
//        
//        automaticallyManagesSubnodes = true
//        
//        if media.isEmpty {
//            assertionFailure("Media must have at least one element. \(media.count) items provided.")
//        }
//        
//        if media.count == 1 {
//            mediaView = NodeMedia(media: media[0])
//        }
//        if media.count > 1 {
//            mediaView = NodeMediaAlbum(media: media)
//        }
//    }
//    
//    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        var child: ASLayoutElement!
//        
//        if let mediaView = mediaView as? NodeMedia {
//            child = mediaView
//        }
//        
//        if let mediaView = mediaView as? NodeMediaAlbum {
//            mediaView.style.width = ASDimension(unit: .fraction, value: 1.0)
//            mediaView.style.height = ASDimension(unit: .points, value: 150)
//            mediaView.collectionNode.clipsToBounds = false
//            let insetMediaLayout = ASInsetLayoutSpec(insets: inset, child: mediaView)
//            child = insetMediaLayout
//        }
//
//        let insetSpec = ASInsetLayoutSpec(insets: inset, child: child)
//        return insetSpec
//    }
//    
//}
