//
//  CellNodeMedia.swift
//  snoogle
//
//  Created by Vincent Moore on 1/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol CellNodeMediaDelegate {
    func didTapMedia(selectedIndex: Int)
}

class CellNodeMedia: ASCellNode {

    let media: MediaElement
    let inset: UIEdgeInsets
    var mediaView = ASImageNode()
    var delegate: CellNodeMediaDelegate? = nil {
        didSet {
            guard let _ = delegate else { return }
            if let mediaView = mediaView as? ASMultiplexImageNode {
                mediaView.isLayerBacked = false
            }
            mediaView.addTarget(self, action: #selector(didTapMedia(gesture:)), forControlEvents: .touchUpInside)
        }
    }
    
    init(media: MediaElement, inset: UIEdgeInsets = .zero) {
        self.media = media
        self.inset = inset
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        if let media = media as? Photo {
            // Specify order of sizes
            let urlKeys: [PhotoSizeType] = [.huge, .large, .medium, .small]
            var idenitifers = [NSCopying & NSObjectProtocol]()
            let urls: [PhotoSizeType:URL?] = [
                .huge: media.urlHuge,
                .large: media.urlLarge,
                .medium: media.urlMedium,
                .small: media.urlSmall
            ]
            
            for key in urlKeys {
                guard let urlValue = urls[key], let _ = urlValue else { continue }
                // TODO: Multiplex identifier casting may be unnecessary
                let castedKey = key.rawValue as NSCopying & NSObjectProtocol
                idenitifers.append(castedKey)
            }
            
            mediaView = ASMultiplexImageNode()
            if let mediaView = mediaView as? ASMultiplexImageNode {
                mediaView.imageIdentifiers = idenitifers
                mediaView.downloadsIntermediateImages = true
                mediaView.dataSource = self
                mediaView.isLayerBacked = true
            }
        }
        
        if let media = media as? Video {
            mediaView = ASVideoNode()
            if let mediaView = mediaView as? ASVideoNode {
                mediaView.url = media.poster
                mediaView.gravity = AVLayerVideoGravityResizeAspectFill
                mediaView.shouldAutoplay = true
                mediaView.shouldAutorepeat = true
                mediaView.placeholderEnabled = true
                mediaView.placeholderFadeDuration = 2.0
                mediaView.backgroundColor = .black
                mediaView.muted = true
            }
        }
    }
    
    func didTapMedia(gesture: UITapGestureRecognizer) {
        guard let delegate = delegate else { return }
        delegate.didTapMedia(selectedIndex: 0)
    }
    
    override func didEnterDisplayState() {
        if let media = media as? Video, let mediaView = mediaView as? ASVideoNode {
            DispatchQueue.global(qos: .background).async {
                if let url = media.url {
                    let asset = AVAsset(url: url)
                    DispatchQueue.main.async {
                        mediaView.asset = asset
                    }
                }
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratio = CGFloat(media.height/media.width)
        let ratioSpec = ASRatioLayoutSpec(ratio: ratio, child: mediaView)
        let insetSpec = ASInsetLayoutSpec(insets: inset, child: ratioSpec)
        return insetSpec
    }
}

extension CellNodeMedia: ASMultiplexImageNodeDataSource {
    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, urlForImageIdentifier imageIdentifier: ASImageIdentifier) -> URL? {
        guard let media = media as? Photo, let imageIdentifier = imageIdentifier as? String else { return nil }
        switch imageIdentifier {
        case "small":
            return media.urlSmall
        case "medium":
            return media.urlMedium
        case "large":
            return media.urlLarge
        case "huge":
            return media.urlHuge
        default:
            return nil
        }
    }
}
