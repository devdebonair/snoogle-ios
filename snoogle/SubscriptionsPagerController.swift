//
//  SubscriptionsPagerController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/1/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SubscriptionsPagerController: ASViewController<ASDisplayNode>, ASPagerDataSource, ASPagerDelegate {
    let pagerNode: ASPagerNode
    init() {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1.0)
        navigationController?.toolbar.isTranslucent = false
        
        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "arrows"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "photo"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "compose"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ], animated: false)
        
        node.addSubnode(pagerNode)
        pagerNode.frame = node.frame
        
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        pagerNode.allowsAutomaticInsetsAdjustment = false
        pagerNode.view.alwaysBounceVertical = false
        
        StatusBar.set(color: UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1.0))
        node.backgroundColor = UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pagerNode.frame = node.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, constrainedSizeForNodeAt index: Int) -> ASSizeRange {
        let size = CGSize(width: node.frame.width, height: node.frame.height)
        return ASSizeRange(min: size, max: size)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return 4
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        return { () -> ASCellNode in
            return ASCellNode(viewControllerBlock: { () -> UIViewController in
                let color = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
                let navigationBarColor = UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1.0)
                let controller = ASNavigationController(rootViewController: SubredditListItemController())
                controller.navigationBar.isTranslucent = false
                controller.navigationBar.barTintColor = navigationBarColor
                controller.view.backgroundColor = color
                return controller
            }, didLoad: nil)
        }
    }
}
