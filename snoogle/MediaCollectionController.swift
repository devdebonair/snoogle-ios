//
//  MediaCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import RealmSwift
import AsyncDisplayKit

class MediaCollectionController: ASViewController<ASDisplayNode>, ASPagerDataSource, ASPagerDelegate, UICollectionViewDelegate {
    
    let media: [MediaElement]
    let pagerNode: ASPagerNode
    
    var startingIndex: Int = 0
    
    let buttonClose = ASButtonNode()
    let progressIndicator = UIProgressView()
    lazy var progressNode: ASDisplayNode = {
        return ASDisplayNode(viewBlock: { () -> UIView in
            return self.progressIndicator
        })
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(media: [MediaElement]) {
        self.media = media
        let layout = ASPagerFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        // TODO: https://stackoverflow.com/questions/42486960/uicollectionview-horizontal-paging-with-space-between-pages
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        pagerNode = ASPagerNode(collectionViewLayout: layout)
        
        super.init(node: ASDisplayNode())
        
        buttonClose.addTarget(self, action: #selector(didTapClose), forControlEvents: .touchUpInside)
        buttonClose.setImage(#imageLiteral(resourceName: "close"), for: [])
        buttonClose.imageNode.contentMode = .scaleAspectFit
        buttonClose.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
        
        pagerNode.setDataSource(self)
        pagerNode.setDelegate(self)
        pagerNode.view.allowsSelection = true
    }

    @objc private func didTapClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setProgress(x: Float(scrollView.contentOffset.x))
    }
    
    func setProgress(x: Float) {
        let xOffset = x
        let totalXOffset = pagerNode.view.contentSize.width - pagerNode.frame.width
        let progress: Float = Float(xOffset) / Float(totalXOffset)
        progressIndicator.setProgress(progress, animated: false)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        self.toggleControls()
    }
    
    func toggleControls() {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
            self.buttonClose.alpha = self.buttonClose.alpha == 0.0 ? 1.0 : 0.0
            self.progressNode.alpha = self.progressNode.alpha == 0.0 ? 1.0 : 0.0
            
            let positionButtonCloseHidden: CGFloat = -self.buttonClose.frame.height
            let positionButtonCloseShow: CGFloat = 10.0
            let positionProgressHidden: CGFloat = self.pagerNode.frame.height
            let positionProgressShow: CGFloat = self.node.frame.height - self.progressNode.frame.height
            
            self.buttonClose.frame.origin.y = self.buttonClose.frame.origin.y == positionButtonCloseHidden ? positionButtonCloseShow : positionButtonCloseHidden
            self.progressNode.frame.origin.y = self.progressNode.frame.origin.y == positionProgressHidden ? positionProgressShow : positionProgressHidden
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.addSubnode(pagerNode)
        node.addSubnode(buttonClose)
        node.addSubnode(progressNode)
        
        pagerNode.frame = node.frame
        pagerNode.backgroundColor = .black
        
        buttonClose.frame.origin = CGPoint(x: 10, y: 10)
        buttonClose.frame.size = CGSize(width: 40, height: 40)
        
        buttonClose.contentEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        
        progressNode.frame.size = CGSize(width: pagerNode.frame.width, height: 30.0)
        progressNode.frame.origin = CGPoint(x: 0, y: node.frame.height - progressNode.frame.height)
        
        progressIndicator.trackTintColor = .darkGray
        progressIndicator.progressTintColor = .white
        
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        pagerNode.allowsAutomaticInsetsAdjustment = false
        pagerNode.view.alwaysBounceVertical = false
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, constrainedSizeForNodeAt index: Int) -> ASSizeRange {
        let min = CGSize(width: pagerNode.frame.width, height: 0.0)
        let max = CGSize(width: pagerNode.frame.width, height: pagerNode.frame.height)
        return ASSizeRange(min: min, max: max)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return media.count
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let mediaItem = media[index]
        return { () -> ASCellNode in
            return CellNodeMedia(media: mediaItem)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pagerNode.frame = node.frame
        pagerNode.reloadData {
            self.pagerNode.scrollToPage(at: self.startingIndex, animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
