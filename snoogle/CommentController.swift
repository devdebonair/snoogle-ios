//
//  CommentController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import RealmSwift
import AsyncDisplayKit

class CommentCollectionController: CollectionController, CommentStoreDelegate {
    
    let store = CommentStore()
    
    override init() {
        super.init()
        flowLayout.sectionFootersPinToVisibleBounds = true
        store.delegate = self
    }
    
    func didUpdateComments(comments: List<Comment>) {
        self.models = [CommentViewModel(comments: comments)]
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        node.backgroundColor = .white
    }
    
    func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CommentCollectionController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return collectionNode.view.contentOffset.y == 0 ? true : false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
