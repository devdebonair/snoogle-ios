////
////  MediaAlbum.swift
////  snoogle
////
////  Created by Vincent Moore on 1/10/17.
////  Copyright © 2017 Vincent Moore. All rights reserved.
////
//
//import Foundation
//import AsyncDisplayKit
//
//class NodeMediaAlbum: ASDisplayNode {
//    
//    var media: [MediaElement]
//    let slider: NodeSlide
//    let models: [ViewModelElement]
//    var collectionNode: ASCollectionNode {
//        return slider.collectionNode
//    }
//    
//    init(media: [MediaElement]) {
//        self.media = media
//        self.models = media.map({ (media: MediaElement) -> ViewModelElement in
//            return AlbumSlideViewModel(media: [media])
//        })
//        
//        self.slider = NodeSlide(models: models)
//        
//        super.init()
//        
//        automaticallyManagesSubnodes = true
//    }
//    
//    override func didLoad() {
//        super.didLoad()
//    }
//    
//    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        return ASInsetLayoutSpec(insets: .zero, child: slider)
//    }
//
//}
