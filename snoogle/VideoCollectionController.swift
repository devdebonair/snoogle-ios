//
//  VideoCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 8/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit
import Hero

class VideoCollectionController: ASViewController<ASDisplayNode> {
    var panGR: UIPanGestureRecognizer!
    let videoNode: CellNodeVideoPlayer
    var portraitFrame: CGRect = .zero
    
    init(movie: Movie) {
        self.videoNode = CellNodeVideoPlayer(media: movie, didLoad: nil)
        super.init(node: ASDisplayNode())
        self.isHeroEnabled = true
        videoNode.player.shouldAutoplay = true
        videoNode.player.muted = true
        videoNode.player.shouldAutorepeat = true
        videoNode.player.backgroundColor = .black
        videoNode.player.placeholderColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.addSubnode(videoNode)
        node.backgroundColor = .black
        videoNode.frame.size.width = node.frame.width
        videoNode.view.center = node.view.center
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        videoNode.view.addGestureRecognizer(panGR)
        videoNode.view.heroModifiers = [.useScaleBasedSizeChange]
        self.portraitFrame = videoNode.frame
    }
    
    @objc func pan() {
        let translation = panGR.translation(in: nil)
        let progress = translation.y.magnitude / 2 / self.node.bounds.height
        switch panGR.state {
        case .began:
            hero_dismissViewController()
        case .changed:
            Hero.shared.update(progress: Double(progress))
            let currentPos = CGPoint(x: translation.x + node.view.center.x, y: translation.y + node.view.center.y)
            Hero.shared.apply(modifiers: [.position(currentPos)], to: videoNode.view)
        default:
            if progress + panGR.velocity(in: nil).y / node.bounds.height > 0.3 {
                Hero.shared.end()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(UIDevice.current.orientation)
        videoNode.view.center = self.node.view.center
        if UIDevice.current.orientation.isPortrait {
            videoNode.view.frame = self.portraitFrame
        }
        
        if UIDevice.current.orientation.isLandscape {
            videoNode.frame = self.node.frame
        }
    }
}
