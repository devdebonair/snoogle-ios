//
//  SubscriptionsPagerController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/1/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import IGListKit
import RealmSwift

protocol SubscriptionsPagerControllerDelegate {
    func didSelectSubreddit(subreddit: SubredditListItemViewModel)
}

class SubscriptionsPagerController: ASViewController<ASDisplayNode>, ASPagerDataSource, ASPagerDelegate, SubscriptionStoreDelegate, SubredditListItemViewModelDelegate, UICollectionViewDelegate {
    
    private enum Pages: Int {
        case favorite = 0
        case recent = 1
        case subscriptions = 2
        case multireddits = 3
    }
    
    private let pageOrder: [Pages] = [.favorite, .recent, .subscriptions, .multireddits]
    private let controllers: [Pages:SubredditListCollectionController] = [
        .favorite: SubredditListCollectionController(title: "Favorite Subreddits"),
        .recent: SubredditListCollectionController(title: "Recent Subreddits"),
        .subscriptions: SubredditListCollectionController(title: "Subscriptions"),
        .multireddits: SubredditListCollectionController(title: "Multireddits")
    ]
    
    let store = SubscriptionStore()
    let pagerNode: ASPagerNode
    let pageBackgroundColor = UIColor(colorLiteralRed: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
    let pageToolbarColor = UIColor(colorLiteralRed: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
    let pageControl: UIPageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    
    var delegate: SubscriptionsPagerControllerDelegate? = nil
    
    init() {
        let layout = ASPagerFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        pagerNode = ASPagerNode(collectionViewLayout: layout)
        
        super.init(node: ASDisplayNode())
        
        pagerNode.setDataSource(self)
        pagerNode.setDelegate(self)
        store.delegate = self
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // Function is called before the page fully transitions and changes
        //      currentPageIndex. This only happens when swiping forwards.
        if pageControl.currentPage == pagerNode.currentPageIndex {
            pageControl.currentPage = pagerNode.currentPageIndex + 1
        } else {
            pageControl.currentPage = pagerNode.currentPageIndex
        }
    }
    
    private func sortAndUpdate(page: Pages, subreddits: List<Subreddit>) {
        var models = [SubredditListItemViewModel]()
        for subreddit in subreddits {
            let model = SubredditListItemViewModel(name: subreddit.displayName, subscribers: subreddit.subscribers, imageUrl: subreddit.urlValidImage)
            model.delegate = self
            models.append(model)
        }
        models.sort { $0.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) < $1.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
        self.controllers[page]?.updateModels(models: models)
    }
    
    func didUpdateRecent(subreddits: List<Subreddit>) {
        sortAndUpdate(page: .recent, subreddits: subreddits)
    }
    
    func didUpdateFavorites(subreddits: List<Subreddit>) {
        sortAndUpdate(page: .favorite, subreddits: subreddits)
    }
    
    func didUpdateSubscriptions(subreddits: List<Subreddit>) {
        sortAndUpdate(page: .subscriptions, subreddits: subreddits)
    }
    
    func didUpdateMultireddits(multireddits: List<Multireddit>) {
        var models = [SubredditListItemViewModel]()
        for multireddit in multireddits {
            var url: URL? = nil
            for subreddit in multireddit.subreddits {
                if let urlValidImage = subreddit.urlValidImage {
                    url = urlValidImage
                    break
                }
            }
            models.append(SubredditListItemViewModel(name: multireddit.displayName, subscribers: 0, imageUrl: url))
        }
        models.sort { $0.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) < $1.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
        self.controllers[.multireddits]?.updateModels(models: models)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.setAccount(id: "hgf1l")
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = false
        let colorValue: CGFloat = 25/255
        navigationController?.toolbar.barTintColor = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 1.0)
        navigationController?.toolbar.isTranslucent = false
        
        node.addSubnode(pagerNode)
        pagerNode.frame = node.frame
        
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
        pagerNode.allowsAutomaticInsetsAdjustment = false
        pagerNode.view.alwaysBounceVertical = false
        
        StatusBar.set(color: pageBackgroundColor)
        pagerNode.backgroundColor = pageBackgroundColor
        
        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: pageControl),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            ], animated: false)
        pageControl.numberOfPages = controllers.count
    }
    
    func didSelectSubreddit(subreddit: SubredditListItemViewModel) {
        guard let delegate = delegate else { return }
        delegate.didSelectSubreddit(subreddit: subreddit)
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, constrainedSizeForNodeAt index: Int) -> ASSizeRange {
        let size = CGSize(width: node.frame.width, height: node.frame.height)
        return ASSizeRange(min: size, max: size)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return pageOrder.count
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let page = pageOrder[index]
        let controllers = self.controllers
        
        let navigationColor = self.pageBackgroundColor
        return { () -> ASCellNode in
            var pageController: SubredditListCollectionController? = nil
            switch page {
            case .favorite:
                pageController = controllers[.favorite]
            case .recent:
                pageController = controllers[.recent]
            case .subscriptions:
                pageController = controllers[.subscriptions]
            case .multireddits:
                pageController = controllers[.multireddits]
            }
            
            guard let guardedPageController = pageController else { return ASCellNode() }
            
            return ASCellNode(viewControllerBlock: { () -> UIViewController in
                let navigation = ASNavigationController(rootViewController: guardedPageController)
                navigation.navigationBar.isTranslucent = false
                navigation.navigationBar.barTintColor = navigationColor
                return navigation
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
