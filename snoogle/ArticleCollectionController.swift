//
//  ArticleCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 4/1/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import RealmSwift
import AsyncDisplayKit
import SafariServices

class ArticleCollectionController: CollectionController, ArticleViewModelDelegate, SubmissionStoreDelegate {
    
    let store = SubmissionStore()
    
    private var commentModel: CommentViewModel? = nil
    private var articleModel: ArticleViewModel? = nil
    
    init(id: String) {
        
        super.init()
        
        flowLayout.sectionFootersPinToVisibleBounds = true
        store.delegate = self
    }
    
    func didUpdateComments(comments: List<Comment>) {
        self.commentModel = CommentViewModel(comments: comments)
        self.load()
    }
    
    func didUpdateSubmission(submission: Submission) {
        self.articleModel = ArticleViewModel(submission: submission)
        self.articleModel?.delegate = self
        self.load()
    }

    func load() {
        var models = [IGListDiffable]()
        if let articleModel = self.articleModel {
            models.append(articleModel)
        }
        if let commentModel = self.commentModel {
            models.append(commentModel)
        }
        self.models = models
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        StatusBar.set(color: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StatusBar.set(color: .clear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionNode.backgroundColor = .white
    }
    
    func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }

    func didTapLink(url: URL) {
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }
}

extension ArticleCollectionController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return collectionNode.view.contentOffset.y == 0 ? true : false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

