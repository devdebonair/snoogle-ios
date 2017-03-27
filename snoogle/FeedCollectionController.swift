//
//  FeedCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 3/26/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import RealmSwift
import AsyncDisplayKit

class FeedCollectionController: CollectionController {
    
    let name: String
    let sort: ListingSort
    var listing: ListingSubreddit? = nil
    var sub: Subreddit? = nil
    var token: NotificationToken? = nil
    
    lazy var toolbar: UIToolbar = {
        let size = CGSize(width: self.node.frame.width, height: 44)
        let frame = CGRect(x: 0, y: self.node.frame.height - size.height, width: size.width, height: size.height)
        let bar = UIToolbar(frame: frame)
        bar.backgroundColor = .white
        bar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "arrows"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "photo"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "compose"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "cogwheel"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        ]
        bar.tintColor = .white
        return bar
    }()
    
    init(name: String, sort: ListingSort = .hot) {
        self.name = name
        self.sort = sort
        
        var realm: Realm!
        do {
            realm = try Realm()
            sub = Query<Subreddit>().key("displayName").eqlStr(name).exec(realm: realm).first
        } catch let error {
            print(error)
        }
        
        
        super.init()
        
        if let sub = sub {
            listing = realm.object(ofType: ListingSubreddit.self, forPrimaryKey: ListingSubreddit.createId(subId: sub.id, sort: sort))
            if let listing = listing {
                token = listing.addNotificationBlock({ (object: ObjectChange) in
                    self.refresh()
                })
                self.refresh()
            }
        } else {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        node.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        let barNode = ASDisplayNode { () -> UIView in
            return self.toolbar
        }
        node.addSubnode(barNode)
        ServiceSubreddit(name: name).listing(sort: sort) { (success) in
            print(success)
        }
    }
    
    func refresh() {
        if let listing = listing {
            models = listing.submissions.map({ (submission: Submission) -> PostViewModel in
                var media = [MediaElement]()
                for item in submission.media {
                    if let type = item.mediaType {
                        switch type {
                        case .photo:
                            let toInsert = Photo(width: item.width, height: item.height, url: item.urlOrigin, urlSmall: item.urlSmall, urlMedium: item.urlMedium, urlLarge: item.urlLarge, info: item.info)
                            media.append(toInsert)
                        case .video:
                            let toInsert = Video(width: item.width, height: item.height, url: item.urlOrigin, poster: item.urlPoster, gif: item.urlGif, info: item.info)
                            media.append(toInsert)
                        }
                    }
                }
                return PostViewModel(id: submission.id, meta: submission.meta, title: submission.title, info: submission.selftextTruncated, media: media, numberOfComments: submission.numComments)
            })
        }
        self.adapter.performUpdates(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SubmissionSectionController()
    }
    
    override func fetch(context: ASBatchContext) {
        ServiceSubreddit(name: name).moreListings(sort: sort) { (success: Bool) in
            context.completeBatchFetching(success)
        }
    }
    
}
