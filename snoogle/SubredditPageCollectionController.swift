//
//  SubredditPageCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 8/3/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

protocol SubredditPageCollectionControllerDelegate {
    func didTapBrowse(name: String)
}

class SubredditPageCollectionController: CollectionController, SubredditPageStoreDelegate {
    let store = SubredditPageStore()
    
    let name: String
    var delegate: SubredditPageCollectionControllerDelegate? = nil
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(name: String) {
        self.name = name
        super.init()
        store.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = []
        
        self.collectionNode.view.bounces = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.fetchSubreddit(name: name)
        store.fetchActivity(name: name)
    }
    
    func didFetchSubreddit(subreddit: Subreddit) {
        models = [SubredditIconStatViewModel(subreddit: subreddit), SubredditAboutViewModel(subreddit: subreddit)]
        self.updateModels()
    }
    
    func didFetchActivity(activity: SubredditActivity) {
        let model = SubredditActivityViewModel(activity: activity)
        models.append(model)
        self.updateModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.isTranslucent = false
        let browseButton = UIBarButtonItem(title: "Browse Subreddit", style: .plain, target: self, action: #selector(didTapBrowse))
        browseButton.setTitleTextAttributes([
            NSForegroundColorAttributeName: ThemeManager.toolbarItem(),
            NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
        ], for: [])
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([flexButton, browseButton, flexButton], animated: false)
    }
    
    func didTapBrowse() {
        guard let delegate = delegate else { return }
        delegate.didTapBrowse(name: self.name)
    }
}

extension SubredditPageCollectionController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return collectionNode.view.contentOffset.y == 0 ? true : false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
