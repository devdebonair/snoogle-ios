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
        super.init(node: ASDisplayNode())
        collectionNode.delegate = self
        transitioningDelegate = self.transition
        self.adapter.setASDKCollectionNode(collectionNode)
        self.node.addSubnode(collectionNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        collectionNode.frame = node.frame
        setTheme()
        receiveThemeChanges()
    }
    
    func setTheme() {
        collectionNode.backgroundColor = ThemeManager.background()
        node.backgroundColor = ThemeManager.background()
        self.navigationController?.navigationBar.tintColor = ThemeManager.navigationItem()
        self.navigationController?.navigationBar.barTintColor = ThemeManager.navigation()
        self.navigationController?.navigationBar.backgroundColor = ThemeManager.navigation()
        self.navigationController?.toolbar.backgroundColor = ThemeManager.toolbar()
        self.navigationController?.toolbar.tintColor = ThemeManager.background()
        self.navigationController?.toolbar.barTintColor = ThemeManager.toolbar()
        StatusBar.set(color: ThemeManager.navigation())
        if let toolbarItems = self.toolbarItems {
            for item in toolbarItems {
                item.tintColor = ThemeManager.toolbarItem()
            }
        }
        if let rightBarButtonItems = self.navigationItem.rightBarButtonItems {
            for item in rightBarButtonItems {
                item.tintColor = ThemeManager.navigationItem()
            }
        }
        if let leftBarButtonItem = self.navigationItem.leftBarButtonItems {
            for item in leftBarButtonItem {
                item.tintColor = ThemeManager.navigationItem()
            }
        }
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

extension CollectionController: ThemableElement {
    func configureTheme() {
        UIView.animate(withDuration: 0.8) {
            self.setTheme()
        }
    }
}
