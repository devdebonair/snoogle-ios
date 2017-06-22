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

class ArticleCollectionController: CollectionController {
    
    let id: String
    var submission: Submission? = nil
    var token: NotificationToken? = nil
    
    init(id: String) {
        self.id = id
        
        super.init()
        
        flowLayout.sectionFootersPinToVisibleBounds = true
        
        DispatchQueue.main.async {
            self.load()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // reset the listing
    fileprivate func load() {
        var realm: Realm!
        do {
            realm = try Realm()
        } catch let error {
            print(error)
        }
        // get submission from realm
        submission = Query<Submission>().key("id").eqlStr(id).exec(realm: realm).first
        
        // add notification for when the listing changes
        guard let guardedSubmission = submission else { return }
        token = guardedSubmission.addNotificationBlock({ (object: ObjectChange) in
            self.refresh()
        })
        
        // Fetch submission from service
        // TODO: fetch submission in article on background thread
//        print("comments coming up")
//        ServiceSubmission(id: guardedSubmission.id).getComments { (success: Bool) in
//            DispatchQueue.main.async {
//                print(guardedSubmission.comments.count)
//            }
//        }
        
        self.refresh()
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
    
    // create map of view models and update ui
    func refresh() {
        guard let guardedSubmission = submission else { return }
//        models = [ArticleViewModel(submission: guardedSubmission), CommentViewModel(comments: guardedSubmission.comments)]
        models = [ArticleViewModel(submission: guardedSubmission)]
        self.adapter.performUpdates(animated: true)
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if let _ = object as? ArticleViewModel {
            return ArticleSectionController()
        }
        return CommentSectionController()
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

