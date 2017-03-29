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
    
    var sub: Subreddit? = nil {
        didSet {
            guard let guardedSub = sub else { return }
            let color = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 228/255, alpha: 1.0)
            let attributeString = NSMutableAttributedString(string: "r/ \(guardedSub.displayName)", attributes: [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)
                ])
            let range = (attributeString.string as NSString).range(of: "r/")
            attributeString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
            
            let textNode = ASTextNode()
            textNode.attributedText = attributeString
            let size = textNode.calculateSizeThatFits(navigationController!.navigationBar.frame.size)
            textNode.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: textNode.view)
        }
    }
    
    var token: NotificationToken? = nil
    
    lazy var toolbar: UIToolbar = {
        let size = CGSize(width: self.node.frame.width, height: 50)
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
        bar.isTranslucent = false
        return bar
    }()
    
    init(name: String, sort: ListingSort = .hot) {
        self.name = name
        self.sort = sort
        
        super.init()

        DispatchQueue.main.async {
            self.loadListing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        
        collectionNode.frame.size.height = collectionNode.frame.height - toolbar.frame.height
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "user"), style: .plain, target: nil, action: nil)
        
        let barNode = ASDisplayNode { () -> UIView in
            return self.toolbar
        }
        navigationController?.view.addSubnode(barNode)
        
        print("requesting service")
        
        ServiceSubreddit(name: name).listing(sort: sort) { success in
            print(success)
            print("sub == nil: \(self.sub == nil)")
            print("listing == nil: \(self.listing == nil)")
            if success {
                if self.sub == nil || self.listing == nil {
                    DispatchQueue.main.async {
                        self.loadListing()
                    }
                }
            }
        }
    }
    
    // reset the listing
    fileprivate func loadListing() {
        var realm: Realm!
        do {
            realm = try Realm()
        } catch let error {
            print(error)
        }
        
        // get subreddit from realm
        sub = Query<Subreddit>().key("displayName").eqlStr(name).exec(realm: realm).first
        
        // get previous listing from realm if sub exists
        guard let guardedSub = sub else { return }
        let listingId = ListingSubreddit.createId(subId: guardedSub.id, sort: sort)
        listing = realm.object(ofType: ListingSubreddit.self, forPrimaryKey: listingId)
        
        // add notification for when the listing changes
        guard let guardedListing = listing else { return }
        token = guardedListing.addNotificationBlock({ (object: ObjectChange) in
            self.refresh()
        })
        
        self.refresh()
    }
    
    // create map of view models and update ui
    func refresh() {
        guard let guardedListing = listing else { return }
        models = guardedListing.submissions.map({ (submission: Submission) -> PostViewModel in
            var media = [MediaElement]()
            for item in submission.media {
                guard let guardedType = item.mediaType else { continue }
                switch guardedType {
                case .photo:
                    let toInsert = Photo(width: item.width, height: item.height, url: item.urlOrigin, urlSmall: item.urlSmall, urlMedium: item.urlMedium, urlLarge: item.urlLarge, info: item.info)
                    media.append(toInsert)
                case .video:
                    let toInsert = Video(width: item.width, height: item.height, url: item.urlOrigin, poster: item.urlPoster, gif: item.urlGif, info: item.info)
                    media.append(toInsert)
                }
            }
            return PostViewModel(id: submission.id, meta: submission.metaIgnoreSub, title: submission.title, info: submission.selftextTruncated, media: media, numberOfComments: submission.numComments, isSticky: submission.stickied)
        })
        self.adapter.performUpdates(animated: true)
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SubmissionSectionController()
    }
    
    override func fetch(context: ASBatchContext) {
        ServiceSubreddit(name: name).moreListings(sort: sort) { (success: Bool) in
            context.completeBatchFetching(success)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
