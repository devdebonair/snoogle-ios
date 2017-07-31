//
//  SearchPageController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/22/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import IGListKit
import RealmSwift

class SearchPageController: ASViewController<ASDisplayNode>, ASPagerDataSource, ASPagerDelegate, SearchStoreDelegate {

    let pagerNode: ASPagerNode
    let store = SearchStore()
    let headerNode: CellNodePagerHeader
    let term: String
    
    fileprivate enum Pages: Int {
        case all = 0
        case subreddits = 1
        case discussions = 2
        case photos = 3
    }
    
    fileprivate let pageOrder: [Pages] = [.all, .subreddits, .discussions, .photos]
    fileprivate let controllers: [Pages: UIViewController] = [
        .all: SearchAllController(),
        .subreddits: SearchSubredditController(),
        .discussions: SearchSubredditController(),
        .photos: SearchPhotoCollectionController()
    ]
    
    init(term: String) {
        let layout = ASPagerFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        pagerNode = ASPagerNode(collectionViewLayout: layout)
        
        self.headerNode = CellNodePagerHeader(sections: ["Everything", "Subreddits", "Discussions", "Photos"])
        self.term = term
        
        super.init(node: ASDisplayNode())
        
        pagerNode.setDataSource(self)
        pagerNode.setDelegate(self)
        
        store.delegate = self
        store.set(term: term)
        
        self.title = term
    }
    
    func didUpdateResults(result: SearchResult) {
        if let allController = controllers[.all] as? SearchAllController {
            var models = [IGListDiffable]()
            if !result.subreddits.isEmpty {
                let subreddits = result.subreddits.count >= 3 ? List<Subreddit>(result.subreddits[0..<3]): result.subreddits
                let model = SubredditListGroupViewModel(subreddits: subreddits)
                model.delegate = self
                models.append(model)
            }
            if !result.photos.isEmpty {
                let photos = result.photos.count >= 6 ? List<Submission>(result.photos[0..<6]) : result.photos
                models.append(PhotoGridGroupViewModel(submissions: photos))
            }
            if !result.discussions.isEmpty {
                let discussions = result.discussions.count >= 3 ? List<Submission>(result.discussions[0..<3]) : result.discussions
                let model = DiscussionGroupViewModel(submissions: discussions)
                model.delegate = self
                models.append(model)
            }
            allController.updateModels(models: models)
        }
        if let subredditController = controllers[.subreddits] as? SearchSubredditController {
            let models = result.subreddits.map({ (subreddit) -> SubredditListItemViewModel in
                let model = SubredditListItemViewModel(name: subreddit.displayName, subtitle: subreddit.publicDescription, imageUrl: subreddit.urlValidImage)
                model.backgroundColor = .white
                model.titleColor = .darkText
                model.subtitleColor = .darkText
                model.delegate = self
                return model
            })
            subredditController.updateModels(models: Array(models))
        }
        if let subredditController = controllers[.discussions] as? SearchSubredditController {
            let models = result.discussions.map({ (submission) -> DiscussionViewModel in
                let model = DiscussionViewModel(submission: submission)
                model.delegate = self
                return model
            })
            subredditController.updateModels(models: Array(models))
        }
        if let photoController = controllers[.photos] as? SearchPhotoCollectionController {
            var models = [MediaViewModel]()
            for submission in result.photos {
                guard let media = submission.media.first, let element = media.getMediaElement() else { continue }
                models.append(MediaViewModel(media: element))
            }
            photoController.models = [MultipleMediaViewModel(models: models)]
            photoController.updateModels()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.contentSize.width
        self.headerNode.setProgress(progress)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.addSubnode(pagerNode)
        node.addSubnode(headerNode)
        
        headerNode.frame = CGRect(x: 0, y: 0, width: node.frame.width, height: 44)
        
        let pagerHeight: CGFloat = node.frame.height - headerNode.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0) - UIApplication.shared.statusBarFrame.height
        pagerNode.frame = CGRect(x: 0, y: headerNode.frame.height, width: node.frame.width, height: pagerHeight)
        
        store.fetchPhotos()
        store.fetchSubreddits()
        store.fetchDiscussions()
        
        pagerNode.view.alwaysBounceVertical = false
        pagerNode.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "arrow-left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "arrow-left")
        
        headerNode.backgroundColor = .white
        headerNode.textColor = UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0)
        headerNode.textFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        headerNode.shadowOffset = CGSize(width: 0, height: 1.0)
        headerNode.clipsToBounds = false
        headerNode.shadowOpacity = 0.10
        headerNode.shadowRadius = 1.0
        headerNode.layer.shadowPath = UIBezierPath(rect: headerNode.bounds).cgPath
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: nil)
        
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        pagerNode.allowsAutomaticInsetsAdjustment = false
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, constrainedSizeForNodeAt index: Int) -> ASSizeRange {
        let max = CGSize(width: pagerNode.frame.width, height: pagerNode.frame.height)
        return ASSizeRange(min: max, max: max)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return pageOrder.count
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
        
        // TODO: Issue where size of node shrinks 64 pixels
        node.frame.size.height = 736.0
        
        headerNode.frame = CGRect(x: 0, y: 0, width: node.frame.width, height: 44)
        let pagerHeight: CGFloat = node.frame.height - headerNode.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0) - UIApplication.shared.statusBarFrame.height
        
        pagerNode.frame = CGRect(x: 0, y: headerNode.frame.height, width: node.frame.width, height: pagerHeight)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.tintColor = .darkText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchPageController: SubredditListItemViewModelDelegate, SubredditListGroupViewModelDelegate {
    func didSelectSubreddit(subreddit: SubredditListItemViewModel) {
        print(subreddit.name)
    }
    func didSelectMoreSubreddits() {
        guard let index = pageOrder.index(of: .subreddits) else { return }
        self.pagerNode.scrollToPage(at: index, animated: true)
    }
}

extension SearchPageController: DiscussionViewModelDelegate, DiscussionGroupViewModelDelegate {
    func didSelectDiscussion(discussion: DiscussionViewModel) {
        let transition = CoverTransition(duration: 0.25, delay: 0.1)
        transition.automaticallyManageGesture = true
        let articleController = ArticleCollectionController(id: discussion.id)
        articleController.store.setSubmission(id: discussion.id)
        articleController.store.fetchComments()
        let controller = NavigationController(rootViewController: articleController)
        controller.transition = transition
        controller.isToolbarHidden = true
        controller.isNavigationBarHidden = true
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    func didSelectMoreDiscussions() {
        guard let index = pageOrder.index(of: .discussions) else { return }
        self.pagerNode.scrollToPage(at: index, animated: true)
    }
}
