//
//  SubmissionStore.swift
//  snoogle
//
//  Created by Vincent Moore on 7/15/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol SubmissionStoreDelegate {
    func didUpdateSubmission(submission: Submission)
    func didUpdateComments(comments: List<Comment>)
}

class SubmissionStore {
    var id: String = ""
    var delegate: SubmissionStoreDelegate? = nil
    var tokenSubmission: RLMNotificationToken? = nil
    var tokenComments: RLMNotificationToken? = nil
    private var user: String? = nil
    private var tokenApp: RLMNotificationToken? = nil
    
    init() {
        do {
            let realm = try Realm()
            let apps = realm.objects(AppUser.self)
            self.tokenApp = apps.observe({ (_) in
                self.user = AppUser.getActiveAccount(realm: realm)?.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            })
            guard let app = apps.first else { return }
            self.user = app.activeAccount?.name
        } catch {
            print(error)
        }
    }
    
    func setSubmission(id: String) {
        self.id = id
        self.tokenSubmission = nil
        self.tokenComments = nil
        
        do {
            let realm = try Realm()
            let submission = realm.object(ofType: Submission.self, forPrimaryKey: id)
            if let submission = submission, let delegate = delegate {
                self.tokenSubmission = submission.observe({ (_) in
                    delegate.didUpdateSubmission(submission: submission)
                })
                delegate.didUpdateSubmission(submission: submission)
            }
        } catch {
            print(error)
        }
        
//        DispatchQueue.global(qos: .background).async {
//            ServiceSubmission(id: id).fetch(completion: { [weak self] (success) in
//                guard let weakSelf = self, success else { return }
//                DispatchQueue.main.async {
//                    do {
//                        let realm = try Realm()
//                        let submission = realm.object(ofType: Submission.self, forPrimaryKey: id)
//                        guard let guardedSubmission = submission, let delegate = weakSelf.delegate else { return }
//                        weakSelf.tokenSubmission = guardedSubmission.observe({ (_) in
//                            delegate.didUpdateSubmission(submission: guardedSubmission)
//                        })
//                        delegate.didUpdateSubmission(submission: guardedSubmission)
//                    } catch {
//                        print(error)
//                    }
//                }
//            })
//        }
    }
    
    func fetchComments(sort: ListingSort = .hot) {
        do {
            let realm = try Realm()
            let comments = realm.object(ofType: SubmissionComments.self, forPrimaryKey: "comments:\(self.id):\(sort.rawValue)")
            if let comments = comments, let delegate = delegate {
                self.tokenComments = comments.observe({ (_) in
                    delegate.didUpdateComments(comments: comments.comments)
                })
                delegate.didUpdateComments(comments: comments.comments)
            }
        } catch {
            print(error)
        }
        
        guard let user = user else { return }
        
        DispatchQueue.global(qos: .background).async {
            ServiceSubmission(id: self.id, user: user).getComments(sort: sort, completion: { [weak self] (success) in
                guard let weakSelf = self, success else { return }
                DispatchQueue.main.async {
                    do {
                        let realm = try Realm()
                        realm.refresh()
                        let comments = realm.object(ofType: SubmissionComments.self, forPrimaryKey: "comments:\(weakSelf.id):\(sort.rawValue)")
                        guard let guardedComments = comments, let delegate = weakSelf.delegate else { return }
                        weakSelf.tokenComments = guardedComments.observe({ (_) in
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
