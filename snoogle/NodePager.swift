//
//  NodePager.swift
//  snoogle
//
//  Created by Vincent Moore on 7/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol NodePagerDelegate {
    func pager(didScroll: ASPagerNode)
    func pager(didScrollToPage index: Int, pager: ASPagerNode)
    func numberOfPages() -> Int
    func pager(controllerAtIndex index: Int) -> UIViewController
}

class NodePager: ASDisplayNode {
    let pagerNode: ASPagerNode
    let headerNode: CellNodePagerHeader
    var delegate: NodePagerDelegate? = nil
    
    override init() {
        let layout = ASPagerFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        pagerNode = ASPagerNode(collectionViewLayout: layout)
        self.headerNode = CellNodePagerHeader(sections: ["Everything", "Subreddits", "Discussions", "Photos"])
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        pagerNode.setDelegate(self)
        pagerNode.setDataSource(self)
    }
    
    override func didLoad() {
        super.didLoad()
        pagerNode.view.alwaysBounceVertical = false
        pagerNode.allowsAutomaticInsetsAdjustment = false
        
        headerNode.backgroundColor = .white
        headerNode.textColor = UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0)
        headerNode.textFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        headerNode.shadowOffset = CGSize(width: 0, height: 1.0)
        headerNode.clipsToBounds = false
        headerNode.shadowOpacity = 0.10
        headerNode.shadowRadius = 1.0
        headerNode.layer.shadowPath = UIBezierPath(rect: headerNode.bounds).cgPath
    }
    
    func scrollToPage(at index: Int, animated: Bool = true) {
        pagerNode.scrollToPage(at: index, animated: animated)
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        headerNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        headerNode.style.height = ASDimension(unit: .points, value: 44.0)
        pagerNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        pagerNode.style.height = ASDimension(unit: .points, value: constrainedSize.max.height - 44.0)
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [headerNode, pagerNode])
        stack.style.flexGrow = 1.0
        return stack
    }
}

extension NodePager: ASPagerDelegate, ASPagerDataSource {
    func pagerNode(_ pagerNode: ASPagerNode, constrainedSizeForNodeAt index: Int) -> ASSizeRange {
        let max = CGSize(width: pagerNode.frame.width, height: pagerNode.frame.height)
        return ASSizeRange(min: max, max: max)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        guard let delegate = delegate else { return 0 }
        return delegate.numberOfPages()
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        guard let delegate = delegate else { return { () -> ASCellNode in return ASCellNode() }}
        let page = delegate.pager(controllerAtIndex: index)
        return { () -> ASCellNode in
            return ASCellNode(viewControllerBlock: { () -> UIViewController in
                return page
            }, didLoad: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.contentSize.width
        self.headerNode.setProgress(progress)
        guard let delegate = delegate else { return }
        delegate.pager(didScroll: pagerNode)
    }
}
