//
//  CellNodePostMovie.swift
//  snoogle
//
//  Created by Vincent Moore on 8/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

protocol CellNodePostMovieDelegate {
    func didTapMovie(movie: CellNodeMinimalMovie)
}

class CellNodeMinimalMovie: CellNode, ASVideoNodeDelegate {
    let media: Movie
    var movieNode: CellNodeVideoPlayer
    var delegate: CellNodePostMovieDelegate? = nil
    let buttonVolume = ASButtonNode()
    
    let imageNodeLogo = ASNetworkImageNode()
    let textNodeDomain = ASTextNode()
    let textNodeAuthor = ASTextNode()
    let textNodeTitle = ASTextNode()
    
    init(media: Movie) {
        buttonVolume.imageNode.image = #imageLiteral(resourceName: "mute")
        buttonVolume.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
        self.media = media
        
        movieNode = CellNodeVideoPlayer(size: .zero, didLoad: nil)
        movieNode.player.shouldAutoplay = true
        movieNode.player.muted = true
        movieNode.player.shouldAutorepeat = true
        
        super.init()
        
        movieNode.player.delegate = self
        self.buttonVolume.addTarget(self, action: #selector(didTapVolume), forControlEvents: .touchUpInside)
    }
    
    override func didLoad() {
        self.buttonVolume.layer.shadowOpacity = 0.25
        self.buttonVolume.layer.shadowRadius = 4.0
    }
    
    func didTap(_ videoNode: ASVideoNode) {
        self.delegate?.didTapMovie(movie: self)
    }
    
    func didTapVolume() {
        self.movieNode.player.muted = !self.movieNode.player.muted
        if self.movieNode.player.muted {
            self.buttonVolume.imageNode.image = #imageLiteral(resourceName: "mute")
        } else {
            self.buttonVolume.imageNode.image = #imageLiteral(resourceName: "volume")
        }
    }
    
    override func didEnterDisplayState() {
        DispatchQueue.global(qos: .background).async {
            if let url = self.media.url {
                let asset = AVAsset(url: url)
                DispatchQueue.main.async {
                    self.movieNode.player.asset = asset
                }
            }
        }
    }
    
    override func buildLayout(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        buttonVolume.style.preferredSize = CGSize(width: 25, height: 25)
        buttonVolume.imageNode.style.preferredSize = buttonVolume.style.preferredSize
        movieNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        movieNode.style.height = ASDimension(unit: .fraction, value: 1.0)
        let insetButton = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 15)
        let insetSpec = ASInsetLayoutSpec(insets: insetButton, child: buttonVolume)
        let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: .minimumSize, child: insetSpec)
        let backgroundSpec = ASBackgroundLayoutSpec(child: relativeSpec, background: movieNode)
        let movieRatioSpec = ASRatioLayoutSpec(ratio: 720/1280, child: backgroundSpec)
        return movieRatioSpec
    }
    
//    func videoNode(_ videoNode: ASVideoNode, didStallAtTimeInterval timeInterval: TimeInterval) {
//        print("loading...")
//    }
//
//    func videoNodeDidStartInitialLoading(_ videoNode: ASVideoNode) {
//        print("loading...")
//    }
//
//    func videoNodeDidRecover(fromStall videoNode: ASVideoNode) {
//        print("resuming...")
//    }
}
