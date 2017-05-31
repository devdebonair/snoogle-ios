//
//  MenuItemCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 5/29/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit

class MenuItemCollectionController: CollectionController {
    
    override init() {
        super.init()
        self.node.backgroundColor = .white
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionNode.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionNode.backgroundColor = .white
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if let _ = object as? SubmissionSortViewModel {
            return SubmissionSortSectionController()
        } else {
            return MenuComposeSectionController()
        }
    }
    
    override func shouldFetch() -> Bool {
        return false
    }
}

extension MenuItemCollectionController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return collectionNode.view.contentOffset.y == 0 ? true : false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
