//
//  CollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 3/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class CollectionController: ASViewController<ASDisplayNode>, ASCollectionDelegate, IGListAdapterDataSource {
    var models = [IGListDiffable]()
    
    lazy var adapter: IGListAdapter = {
        let adapter = IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapter.dataSource = self
        return adapter
    }()
    
    let flowLayout = UICollectionViewFlowLayout()
    let collectionNode: ASCollectionNode
    
    init() {
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: ASDisplayNode())
        collectionNode.delegate = self
        self.adapter.setASDKCollectionNode(collectionNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        node.frame.size.height = node.frame.height - UIApplication.shared.statusBarFrame.height - (navigationController?.navigationBar.frame.height ?? 0)
        collectionNode.frame = node.bounds
        collectionNode.backgroundColor = .clear
        node.addSubnode(collectionNode)
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    func fetch(context: ASBatchContext) {
        return
    }
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return models
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
    func shouldFetch() -> Bool {
        return true
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return shouldFetch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

