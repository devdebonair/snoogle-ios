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
import CoreMotion
import ImageIO

class VideoCollectionController: ASViewController<ASDisplayNode> {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate enum Pages: Int {
        case comments = 0
    }
    
    fileprivate var orientation: UIDeviceOrientation = .portrait {
        didSet {
            self.panGR.isEnabled = self.orientation == .portrait
        }
    }
    
    fileprivate let controllers: [Pages: UIViewController] = [
        .comments: CommentCollectionController()
    ]
    
    fileprivate let pageOrder: [Pages] = [.comments]
    fileprivate var originalVideoFrame: CGRect = .zero
    fileprivate var originalPagerFrame: CGRect = .zero
    
    fileprivate let pager: NodePager
    fileprivate var submission: Submission
    fileprivate var panGR: UIPanGestureRecognizer!
    fileprivate let motionManager: CMMotionManager
    
    let videoNode: CellNodeVideoPlayer
    
    init(movie: Movie, submission: Submission) {
        self.submission = submission
        self.pager = NodePager()
        self.videoNode = CellNodeVideoPlayer(size: CGSize(width: 1280, height: 760))
        self.motionManager = CMMotionManager()
        
        super.init(node: ASDisplayNode())
        
        self.isHeroEnabled = true
        
        videoNode.player.shouldAutoplay = true
        videoNode.player.muted = true
        videoNode.player.backgroundColor = .black
        videoNode.player.url = movie.poster
        videoNode.player.shouldAutoplay = true
        videoNode.player.backgroundColor = .black
        videoNode.player.player?.volume = 1.0
        videoNode.player.muted = false
        videoNode.player.placeholderEnabled = true
        videoNode.player.gravity = AVLayerVideoGravityResizeAspectFill
        videoNode.alpha = 0.0
        videoNode.contentMode = .scaleAspectFill
        
        self.pager.delegate = self
        self.pager.backgroundColor = .white
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            if let error = error {
                print(error)
            }
            guard let data = data else { return }
            if data.acceleration.x >= 0.75 {
                self.rotate(orientation: .landscapeLeft)
            }
            else if data.acceleration.x <= -0.75 {
                self.rotate(orientation: .landscapeRight)
            }
            else if data.acceleration.y <= -0.75 {
                self.rotate(orientation: .portrait)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let commentController = self.controllers[.comments] as? CommentCollectionController {
            commentController.store.fetchComments(submissionId: submission.id, sort: .hot)
        }
        UIView.animate(withDuration: 0.2) {
            self.videoNode.alpha = 1.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.addSubnode(pager)
        self.node.addSubnode(videoNode)
        
        node.backgroundColor = .black
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        videoNode.frame.origin = .zero
        videoNode.frame.size = self.videoNode.size.fit(in: self.node.frame.size)
        videoNode.player.view.addGestureRecognizer(panGR)
        
        self.originalVideoFrame = videoNode.frame
        
        if let url = submission.urlOrigin, let apiURL = URL(string: "media", relativeTo: Service().base) {
            Network().url(apiURL).query(key: "url", item: url.absoluteString).get().parse(type: .json).success { [weak self] (data, response) in
                guard let weakSelf = self, let data = data as? [[String:Any]] else { return }
                guard let mediaJSON = data.first, let media = Media(JSON: mediaJSON) else { return }
                DispatchQueue.main.async {
                    weakSelf.videoNode.assetURL = media.urlOrigin
                }
            }.sendHTTP()
        }
        
        pager.frame.size.width = node.frame.width
        pager.frame.size.height = node.frame.height - videoNode.frame.height
        pager.frame.origin = CGPoint(x: 0, y: videoNode.frame.height)
        
        self.originalPagerFrame = pager.frame
    }
    
    @objc func pan() {
        let translation = panGR.translation(in: nil)
        let progress = translation.y.magnitude / 2 / self.node.bounds.height
        switch panGR.state {
        case .began:
            hero_dismissViewController()
            UIView.animate(withDuration: 0.5, animations: {
                self.pager.frame.origin.y = self.node.frame.height
            })
        case .changed:
            Hero.shared.update(progress)
            let currentPos = CGPoint(x: translation.x + videoNode.view.center.x, y: translation.y + videoNode.view.center.y)
            Hero.shared.apply(modifiers: [.position(currentPos)], to: videoNode.view)
        default:
            if progress + panGR.velocity(in: nil).y / node.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.pager.frame = self.originalPagerFrame
                })
                Hero.shared.cancel()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBar.hide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBar.show()
    }
    
    func rotate(orientation: UIDeviceOrientation) {
        guard orientation != self.orientation else { return }
        self.orientation = orientation
        switch orientation {
        case .portrait:
            UIView.animate(withDuration: 0.3, animations: {
                self.videoNode.view.transform = .identity
                self.videoNode.frame = self.originalVideoFrame
            })
        case .landscapeLeft:
            UIView.animate(withDuration: 0.3, animations: {
                self.videoNode.view.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                self.videoNode.frame.size.width = 736
                self.videoNode.frame.size.height = 414
                self.videoNode.position = self.node.position
            })
        case .landscapeRight:
            UIView.animate(withDuration: 0.3, animations: {
                self.videoNode.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                self.videoNode.frame.size.width = 736
                self.videoNode.frame.size.height = 414
                self.videoNode.frame.origin = .zero
                self.videoNode.position = self.node.position
            })
        default:
            return
        }
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
