////
////  NodeMedia.swift
////  snoogle
////
////  Created by Vincent Moore on 1/10/17.
////  Copyright © 2017 Vincent Moore. All rights reserved.
////
//
//import Foundation
//import AsyncDisplayKit
//
//class NodeMedia: ASDisplayNode {
//
//    let media: MediaElement
//    var mediaView = ASImageNode()
//    let inset: UIEdgeInsets
//    
//    init(media: MediaElement, inset: UIEdgeInsets = .zero) {
//        self.media = media
//        self.inset = inset
//        
//        super.init()
//        
//        automaticallyManagesSubnodes = true
//        
//        if let media = media as? Photo {
//            if let _ = media.urlSmall, let _ = media.urlMedium, let _ = media.urlLarge {
//                mediaView = ASMultiplexImageNode()
//                if let mediaView = mediaView as? ASMultiplexImageNode {
//                    mediaView.imageIdentifiers = ["large" as NSCopying & NSObjectProtocol, "medium" as NSCopying & NSObjectProtocol, "small" as NSCopying & NSObjectProtocol]
//                    mediaView.downloadsIntermediateImages = true
//                    mediaView.dataSource = self
//                    mediaView.isLayerBacked = true
//                }
//            } else {
//                mediaView = ASNetworkImageNode()
//                if let mediaView = mediaView as? ASNetworkImageNode {
//                    mediaView.url = media.url
//                    mediaView.contentMode = .scaleAspectFill
//                    mediaView.isLayerBacked = true
//                }
//            }
//        }
//        
//        if let media = media as? Video {
//            mediaView = ASVideoNode()
//            if let mediaView = mediaView as? ASVideoNode {
//                mediaView.url = media.poster
//                mediaView.gravity = AVLayerVideoGravityResizeAspectFill
//                mediaView.shouldAutoplay = true
//                mediaView.shouldAutorepeat = true
//                mediaView.placeholderEnabled = true
//                mediaView.placeholderFadeDuration = 2.0
//                mediaView.backgroundColor = .black
//                mediaView.muted = true
//                mediaView.isLayerBacked = true
//            }
//        }
//    }
//    
//    override func didEnterVisibleState() {
//        if let media = media as? Video, let mediaView = mediaView as? ASVideoNode {
//            DispatchQueue.global(qos: .background).async {
//                if let url = media.url {
//                    let asset = AVAsset(url: url)
//                    DispatchQueue.main.async {
//                        mediaView.asset = asset
//                    }
//                }
//            }
//        }
//    }
//    
//    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        let ratio = CGFloat(media.height/media.width)
//        let ratioSpec = ASRatioLayoutSpec(ratio: ratio, child: mediaView)
//        let insetSpec = ASInsetLayoutSpec(insets: inset, child: ratioSpec)
//        return insetSpec
//    }
//    
//}
//
//extension NodeMedia: ASMultiplexImageNodeDataSource {
//    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, urlForImageIdentifier imageIdentifier: ASImageIdentifier) -> URL? {
//        guard let media = media as? Photo, let imageIdentifier = imageIdentifier as? String else { return nil }
//        switch imageIdentifier {
//        case "small":
//            return media.urlSmall
//        case "medium":
//            return media.urlMedium
//        case "large":
//            return media.urlLarge
//        default:
//            return nil
//        }
//    }
//}
