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

class CollectionController: ASViewController<ASCollectionNode>, ASCollectionDelegate, IGListAdapterDataSource {
    var transition: Transition? = nil
    let flowLayout: UICollectionViewLayout
    let collectionNode: ASCollectionNode
    
    var models = [IGListDiffable]()
    
    lazy var adapter: IGListAdapter = {
        let adapter = IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapter.dataSource = self
        return adapter
    }()
    
    init(collectionLayout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        self.flowLayout = collectionLayout
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.delegate = self
        transitioningDelegate = self.transition
        self.adapter.setASDKCollectionNode(collectionNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateModels()
    }
    
    func fetch(context: ASBatchContext) {
        return
    }
    
    func sectionController() -> GenericSectionController {
        return GenericSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
    func shouldFetch() -> Bool {
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionController {
    func updateModels(animated: Bool = true, completion: IGListUpdaterCompletion? = nil) {
        self.adapter.performUpdates(animated: animated, completion: completion)
    }
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return models
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return self.sectionController()
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return shouldFetch()
    }
}
