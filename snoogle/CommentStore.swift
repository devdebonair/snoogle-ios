//
//  CommentStore.swift
//  snoogle
//
//  Created by Vincent Moore on 7/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol CommentStoreDelegate {
    func didUpdateComments(comments: List<Comment>)
}

class CommentStore {
    var id: String = ""
    var delegate: CommentStoreDelegate? = nil
    var tokenComments: RLMNotificationToken? = nil
    
    func fetchComments(submissionId: String, sort: ListingSort = .hot) {
        self.id = submissionId
        do {
            let realm = try Realm()
            let comments = realm.object(ofType: SubmissionComments.self, forPrimaryKey: "comments:\(self.id):\(sort.rawValue)")
            if let comments = comments, let delegate = delegate {
                self.tokenComments = comments.addNotificationBlock({ (_) in
                    delegate.didUpdateComments(comments: comments.comments)
                })
                delegate.didUpdateComments(comments: comments.comments)
            }
        } catch {
            print(error)
        }
        
        DispatchQueue.global(qos: .background).async {
            ServiceSubmission(id: self.id).getComments(sort: sort, completion: { [weak self] (success) in
                guard let weakSelf = self, success else { return }
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        let comments = realm.object(ofType: SubmissionComments.self, forPrimaryKey: "comments:\(weakSelf.id):\(sort.rawValue)")
                        guard let guardedComments = comments, let delegate = weakSelf.delegate else { return }
                        weakSelf.tokenComments = guardedComments.addNotificationBlock({ (_) in
                            delegate.didUpdateComments(comments: guardedComments.comments)
                        })
                        delegate.didUpdateComments(comments: guardedComments.comments)
                    } catch {
                        print(error)
                    }
                }
            })
        }
    }
}
