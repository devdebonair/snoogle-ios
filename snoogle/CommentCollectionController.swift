//
//  CommentCollectionController.swift
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
    var titleLabel: UILabel = UILabel()
    
    init() {
        super.init()
        if let flowLayout = flowLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionFootersPinToVisibleBounds = true
        }
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
        
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        
        if let navigationController = navigationController {
            self.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBlack)
            self.titleLabel.textColor = ThemeManager.navigationItem()
            let size = self.titleLabel.sizeThatFits(navigationController.navigationBar.frame.size)
            self.titleLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.titleLabel)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
        
        let bottomInset: CGFloat = (self.navigationController?.toolbar.frame.height ?? 0) + self.bottomLayoutGuide.length + 20
        collectionNode.view.contentInset = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: bottomInset, right: 0)
    }
    
    func dismissController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let transition = self.navigationController?.transitioningDelegate as? CardTransition {
            transition.finish()
        }
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
