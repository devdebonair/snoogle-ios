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
        submission = realm.object(ofType: Submission.self, forPrimaryKey: id)
        
        // add notification for when the listing changes
        guard let guardedSubmission = submission else { return }
        token = guardedSubmission.addNotificationBlock({ (object: ObjectChange) in
            self.refresh()
        })
        
        self.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionNode.backgroundColor = .white
    }
    
    // create map of view models and update ui
    func refresh() {
        guard let guardedSubmission = submission else { return }
        models = [ArticleViewModel(submission: guardedSubmission)]
        self.adapter.performUpdates(animated: true)
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return ArticleSectionController()
    }
    
    override func shouldFetch() -> Bool {
        return false
    }
    
}
