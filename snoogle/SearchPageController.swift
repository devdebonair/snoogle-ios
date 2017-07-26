//
//  SearchPageController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import IGListKit
import RealmSwift

class SearchPageController: ASViewController<ASDisplayNode> , ASPagerDataSource, ASPagerDelegate, SearchStoreDelegate {

    let pagerNode: ASPagerNode
    let store = SearchStore()
    
    private enum Pages: Int {
        case all = 0
    }
    
    private let pageOrder: [Pages] = [.all]
    private let controllers: [Pages: UIViewController] = [
        .all: SearchAllController()
    ]
    
    init() {
        let layout = ASPagerFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        // TODO: https://stackoverflow.com/questions/42486960/uicollectionview-horizontal-paging-with-space-between-pages
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        pagerNode = ASPagerNode(collectionViewLayout: layout)
        
        super.init(node: ASDisplayNode())
        
        pagerNode.setDataSource(self)
        pagerNode.setDelegate(self)
    }
    
    func didUpdateResults(result: SearchResult) {
        guard let allController = controllers[.all] as? SearchAllController else { return }
        var models = [IGListDiffable]()
        if !result.subreddits.isEmpty {
            let subreddits = result.subreddits.count >= 3 ? List<Subreddit>(result.subreddits[0..<3]): result.subreddits
            models.append(SubredditListGroupViewModel(subreddits: subreddits))
        }
        if !result.photos.isEmpty {
            let photos = result.photos.count >= 6 ? List<Submission>(result.photos[0..<6]) : result.photos
            models.append(PhotoGridGroupViewModel(submissions: photos))
        }
        if !result.discussions.isEmpty {
            let discussions = result.discussions.count >= 3 ? List<Submission>(result.discussions[0..<3]) : result.discussions
            models.append(DiscussionGroupViewModel(submissions: discussions))
        }
        allController.updateModels(models: models)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.addSubnode(pagerNode)
        
        store.set(term: "spiderman")
        store.fetchPhotos()
        store.fetchSubreddits()
        store.fetchDiscussions()
        store.delegate = self
        
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        pagerNode.allowsAutomaticInsetsAdjustment = false
        pagerNode.view.alwaysBounceVertical = false
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, constrainedSizeForNodeAt index: Int) -> ASSizeRange {
        let max = CGSize(width: pagerNode.frame.width, height: pagerNode.frame.height)
        return ASSizeRange(min: max, max: max)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return 1
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let page = controllers[pageOrder[index]]
        return { () -> ASCellNode in
            guard let guardedPage = page else { return ASCellNode() }
            return ASCellNode(viewControllerBlock: { () -> UIViewController in
                return guardedPage
            }, didLoad: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pagerNode.frame = node.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
