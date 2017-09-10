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
    var submission: Submission
    let pager: NodePager
    
    fileprivate enum Pages: Int {
        case details = 0
    }
    fileprivate let pageOrder: [Pages] = [.details]
    fileprivate let controllers: [Pages: UIViewController] = [
        .details: CollectionController()
    ]
    
    init(movie: Movie, submission: Submission) {
        self.submission = submission
        self.pager = NodePager()
        self.videoNode = CellNodeVideoPlayer(size: CGSize(width: movie.width, height: movie.height))
        
        super.init(node: ASDisplayNode())
        
        self.isHeroEnabled = true
        
        videoNode.player.shouldAutoplay = true
        videoNode.player.muted = true
        videoNode.player.backgroundColor = .black
        videoNode.player.placeholderColor = .black
        videoNode.player.url = movie.poster
        videoNode.player.shouldAutoplay = true
        videoNode.player.backgroundColor = .black
        videoNode.player.player?.volume = 1.0
        videoNode.player.muted = false
        
        self.pager.delegate = self
        self.pager.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.addSubnode(pager)
        self.node.addSubnode(videoNode)
        
        node.backgroundColor = .black
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        videoNode.frame.origin = .zero
        videoNode.frame.size.width = node.frame.width
        videoNode.player.view.addGestureRecognizer(panGR)
        videoNode.view.heroModifiers = [.useScaleBasedSizeChange]
        
        if let url = submission.urlOrigin, let apiURL = URL(string: "media", relativeTo: Service().base) {
            Network().url(apiURL).query(key: "url", item: url.absoluteString).get().parse(type: .json).success { [weak self] (data, response) in
                guard let weakSelf = self, let data = data as? [[String:Any]] else { return }
                guard let mediaJSON = data.first, let media = Media(JSON: mediaJSON) else { return }
                DispatchQueue.main.async {
                    weakSelf.videoNode.player.assetURL = media.urlOrigin
                }
            }.sendHTTP()
        }
        
        pager.frame.size.width = node.frame.width
        pager.frame.size.height = node.frame.height - videoNode.frame.height
        pager.frame.origin = CGPoint(x: 0, y: videoNode.frame.height)
    }
    
    @objc func pan() {
        let translation = panGR.translation(in: nil)
        let progress = translation.y.magnitude / 2 / self.node.bounds.height
        switch panGR.state {
        case .began:
            hero_dismissViewController()
        case .changed:
            Hero.shared.update(progress)
            let currentPos = CGPoint(x: translation.x + videoNode.view.center.x, y: translation.y + videoNode.view.center.y)
            Hero.shared.apply(modifiers: [.position(currentPos)], to: videoNode.view)
        default:
            if progress + panGR.velocity(in: nil).y / node.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {}
        if UIDevice.current.orientation.isLandscape {}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBar.hide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBar.show()
    }
}

extension VideoCollectionController: NodePagerDelegate {
    func pager(didScroll: ASPagerNode) {}
    func pager(didScrollToPage index: Int, pager: ASPagerNode) {}
    
    func numberOfPages() -> Int {
        return pageOrder.count
    }
    
    func pager(controllerAtIndex index: Int) -> UIViewController {
        let page = controllers[pageOrder[index]]
        guard let guardedPage = page else { return UIViewController() }
        return guardedPage
    }
}
