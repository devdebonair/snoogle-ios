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
    init(media: [MediaElement]) {
        self.media = media
        let layout = ASPagerFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        pagerNode = ASPagerNode(collectionViewLayout: layout)
        
        super.init(node: ASDisplayNode())
        
        pagerNode.setDataSource(self)
        pagerNode.setDelegate(self)
    }
    
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        // Function is called before the page fully transitions and changes
//        //      currentPageIndex. This only happens when swiping forwards.
//        if pageControl.currentPage == pagerNode.currentPageIndex {
//            pageControl.currentPage = pagerNode.currentPageIndex + 1
//        } else {
//            pageControl.currentPage = pagerNode.currentPageIndex
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.addSubnode(pagerNode)
        pagerNode.frame = node.frame
        
        pagerNode.backgroundColor = .black
        
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        pagerNode.allowsAutomaticInsetsAdjustment = false
        pagerNode.view.alwaysBounceVertical = false
        
        StatusBar.set(color: .black)
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, constrainedSizeForNodeAt index: Int) -> ASSizeRange {
        let size = CGSize(width: node.frame.width, height: .infinity)
        return ASSizeRange(min: .zero, max: size)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
