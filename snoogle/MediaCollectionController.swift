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

class MediaCollectionController: ASViewController<ASDisplayNode>, ASPagerDataSource, ASPagerDelegate {
    
    private var isInitialAppearance = true
    
    let media: [MediaElement]
    let pagerNode: ASPagerNode
    
    var startingIndex: Int = 0
    
    let buttonClose = ASButtonNode()
    let actionBar = CellNodeMediaPageActionBar()
    
    var startingTime: CMTime = CMTimeMake(0,0)
    
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
        let totalXOffset = scrollView.contentSize.width - scrollView.frame.width
        let progress: Float = Float(scrollView.contentOffset.x) / Float(totalXOffset)
        actionBar.setProgress(progress)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        self.toggleControls()
    }
    
    func toggleControls() {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
            self.buttonClose.alpha = self.buttonClose.alpha == 0.0 ? 1.0 : 0.0
            self.actionBar.alpha = self.actionBar.alpha == 0.0 ? 1.0 : 0.0
            
            let positionButtonCloseHidden: CGFloat = -self.buttonClose.frame.height
            let positionButtonCloseShow: CGFloat = 10.0
            let positionMenuHidden: CGFloat = self.pagerNode.frame.height
            let positionMenuShow: CGFloat = self.pagerNode.frame.height - (self.pagerNode.frame.height * 0.07)
            
            self.buttonClose.frame.origin.y = self.buttonClose.frame.origin.y == positionButtonCloseHidden ? positionButtonCloseShow : positionButtonCloseHidden
            self.actionBar.frame.origin.y = self.actionBar.frame.origin.y == positionMenuHidden ? positionMenuShow : positionMenuHidden
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.addSubnode(pagerNode)
        node.addSubnode(buttonClose)
        node.addSubnode(actionBar)
        
        pagerNode.backgroundColor = .black
        
        pagerNode.frame = node.frame
        buttonClose.frame.size = CGSize(width: 40, height: 40)
        actionBar.frame.size = CGSize(width: pagerNode.frame.width, height: 44.0)
        
        buttonClose.frame.origin = CGPoint(x: 10, y: 10)
        actionBar.frame.origin = CGPoint(x: 0, y: pagerNode.frame.height - (pagerNode.frame.height * 0.07))
        
        buttonClose.contentEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        pagerNode.allowsAutomaticInsetsAdjustment = false
        pagerNode.view.alwaysBounceVertical = false
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, constrainedSizeForNodeAt index: Int) -> ASSizeRange {
        let max = CGSize(width: pagerNode.frame.width, height: pagerNode.frame.height)
        return ASSizeRange(min: max, max: max)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return media.count
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let mediaItem = media[index]
        let startingTime = self.startingTime
        let startingIndex = self.startingIndex
        return { () -> ASCellNode in
            let cell = CellNodeMediaPage(media: mediaItem)
            if let _ = cell.cellMedia.mediaView as? ASVideoNode, index == startingIndex {
                cell.cellMedia.initialTime = startingTime
            }
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StatusBar.hide()
        pagerNode.frame = node.frame
        
        if isInitialAppearance {
            pagerNode.reloadData {
                self.pagerNode.scrollToPage(at: self.startingIndex, animated: false)
            }
        }
        isInitialAppearance = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StatusBar.show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
