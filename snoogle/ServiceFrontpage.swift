//
//  ServiceFrontpage.swift
//  snoogle
//
//  Created by Vincent Moore on 3/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceFrontpage: ServiceReddit {
    func listing(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        let user = self.user
        guard !user.isEmpty else {
            guard let completion = completion else { return }
            return completion(false)
        }
        requestListing(sort: sort) { (json: [String : Any]?) in
            guard let json = json, let submissionJSON = json["data"] as? [[String:Any]] else {
                guard let completion = completion else { return }
                return completion(false)
            }
            let jsonToSave: [String:Any] = [
                "user": user,
                "sort": sort.rawValue,
                "submissions": submissionJSON
            ]
            
            guard let listing = ListingFrontpage(JSON: jsonToSave) else {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(listing, update: true)
                }
            } catch {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            guard let completion = completion else { return }
            return completion(true)
        }
    }
    
    func moreListings(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        let user = self.user
        var listing: ListingFrontpage? = nil
        
        do {
            let realm = try Realm()
            let listingId = "frontpage:\(user):\(sort.rawValue)"
            listing = realm.object(ofType: ListingFrontpage.self, forPrimaryKey: listingId)
        } catch {
            print(error)
            guard let completion = completion else { return }
            return completion(false)
        }
        
        guard let _ = listing, let guardedAfter = listing?.after else {
            return self.listing(sort: sort, completion: completion)
        }
        
        requestListing(sort: sort, after: guardedAfter) { (json: [String:Any]?) in
            guard let json = json, let submissionJSON = json["data"] as? [[String:Any]] else {
                guard let completion = completion else { return }
                return completion(false)
            }
            
            do {
                let realm = try Realm()
                let listingId = "frontpage:\(user):\(sort.rawValue)"
                let listing = realm.object(ofType: ListingFrontpage.self, forPrimaryKey: listingId)
                
                guard let guardedListing = listing else {
                    guard let completion = completion else { return }
                    return completion(false)
                }
                
                var toDelete = [Submission]()
                var toAdd = [Submission]()
                for subJSON in submissionJSON {
                    guard let submission = Submission(JSON: subJSON) else { continue }
                    let existingSubmission = realm.object(ofType: Submission.self, forPrimaryKey: submission.id)
                    if let existingSubmission = existingSubmission {
                        toDelete.append(existingSubmission)
                    }
                    toAdd.append(submission)
                }
                
                try realm.write {
                    realm.delete(toDelete)
                    guardedListing.submissions.append(objectsIn: toAdd)
                }
            } catch {
                print(error)
                guard let completion = completion else { return }
                return completion(false)
            }
            
            guard let completion = completion else { return }
            return completion(true)
        }
    }
}

extension ServiceFrontpage {
    func requestListing(sort: ListingSort = .hot, after: String? = nil, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "frontpage/\(sort.rawValue)", relativeTo: base)!
        guard var network = self.oauthRequest() else { return completion(nil) }
        network = network
            .get()
            .url(url)
        
        if let after = after {
            network = network.query(key: "after", item: after)
        }
        
        network.parse(type: .json)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
}
