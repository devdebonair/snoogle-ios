//
//  ViewController.swift
//  snoogle
//
//  Created by Vincent Moore on 12/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class FeedViewController: ASViewController<ASCollectionNode>, ASCollectionDelegate, ASCollectionDataSource {
    let subreddit: String
    var after: String? = nil
    let subSort: Listing.SortType
    var shouldUpdate: Bool = false
    
    var model: [Listing] = []
    var posts: [PostViewModel] = []
    
    enum SubredditType: Int {
        case custom = 0
        case frontpage = 1
    }
    
    let flowLayout: UICollectionViewFlowLayout
    
    private let type: SubredditType
    
    init(subreddit: String, sort: Listing.SortType = .hot, type: SubredditType = .custom) {
        self.subreddit = subreddit
        self.subSort = sort
        self.type = type
        
        flowLayout = UICollectionViewFlowLayout()
        
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        
        super.init(node: collectionNode)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        
        node.delegate = self
        node.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        let fetchHandler = { (listings: [Listing], isFinished: Bool, after: String?) in
            self.model.append(contentsOf: listings)
            for listing in listings {
                var postMedia = [MediaElement]()
                if let media = listing.media {
                    postMedia.append(media)
                }
                if let album = listing.album {
                    postMedia.append(contentsOf: album)
                }
                let post = PostViewModel(meta: listing.meta, title: listing.title, description: listing.selftext_truncated, media: postMedia, numberOfComments: listing.num_comments)
                self.posts.append(post)
            }
            self.shouldUpdate = !isFinished
            self.after = after
            self.node.reloadData()
        }
        
        switch type {
        case .frontpage:
            Subreddit.fetchFrontPage(sort: subSort, completion: fetchHandler)
        case .custom:
            Subreddit.fetchListing(name: subreddit, sort: subSort, completion: fetchHandler)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let post = posts[indexPath.section]
        return { _ -> ASCellNode in
            return post.cellAtRow(indexPath: indexPath)
        }
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return posts.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        let post = posts[section]
        return post.numberOfCells()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let width: CGFloat = node.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let max = CGSize(width: width, height: CGFloat(FLT_MAX))
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return shouldUpdate
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        
        let batchHandler = { (listings: [Listing], isFinished: Bool, after: String?) in
            self.after = after
            self.shouldUpdate = !isFinished
            
            let prevModelCount = self.posts.count
            
            self.model.append(contentsOf: listings)
            
            for listing in listings {
                var postMedia = [MediaElement]()
                if let media = listing.media {
                    postMedia.append(media)
                }
                if let album = listing.album {
                    postMedia.append(contentsOf: album)
                }
                let post = PostViewModel(meta: listing.meta, title: listing.title, description: listing.selftext_truncated, media: postMedia, numberOfComments: listing.num_comments)
                self.posts.append(post)
            }
            
            let set: IndexSet = IndexSet(integersIn: prevModelCount..<self.posts.count)
            self.node.insertSections(set)
            context.completeBatchFetching(true)
        }
        
        switch type {
        case .frontpage:
            Subreddit.fetchFrontPage(after: after, sort: subSort, completion: batchHandler)
        case .custom:
            Subreddit.fetchListing(name: subreddit, after: after, sort: subSort, completion: batchHandler)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let listing = model[indexPath.section]
        let content = listing.selftext.components(separatedBy: .newlines)
        var articleMedia: [MediaElement] = []
        
        if let media = listing.media {
            articleMedia = [media]
        }
        
        if let album = listing.album {
            articleMedia = album
        }
        
        let article = ArticleViewModel(meta: listing.meta, title: listing.title, media: articleMedia, content: content)
        let controller = ArticleViewController(article: article, listingId: listing.id, numberOfComments: listing.num_comments)
        present(controller, animated: true, completion: nil)
    }
    
}
