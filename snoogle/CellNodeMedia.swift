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
    func didTapMedia(media: CellNodeMedia)
}

class CellNodeMedia: CellNode {

    let media: MediaElement
    var mediaView = ASImageNode()
    var initialTime: CMTime? = nil
    var delegate: CellNodeMediaDelegate? = nil {
        didSet {
            DispatchQueue.main.async {
                guard let _ = self.delegate else { self.mediaView.isLayerBacked = true; return }
                self.mediaView.isLayerBacked = false
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapMedia(gesture:)))
                self.view.addGestureRecognizer(tap)
            }
        }
    }
    
    init(media: MediaElement, didLoad: ((CellNode)->Void)? = nil) {
        self.media = media
        
        super.init(didLoad: didLoad)

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
                mediaView.contentMode = .scaleAspectFill
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
                mediaView.isUserInteractionEnabled = false
                mediaView.delegate = self
            }
        }
    }
    
    func didTapMedia(gesture: UITapGestureRecognizer) {
        delegate?.didTapMedia(media: self)
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
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratio = CGFloat(media.height/media.width)
        let ratioSpec = ASRatioLayoutSpec(ratio: ratio, child: mediaView)
        return ratioSpec
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

extension CellNodeMedia: ASVideoNodeDelegate {
    func videoNode(_ videoNode: ASVideoNode, didSetCurrentItem currentItem: AVPlayerItem) {
        if let initialTime = initialTime {
            currentItem.seek(to: initialTime)
        }
    }
}
