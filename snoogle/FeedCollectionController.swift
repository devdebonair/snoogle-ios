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
import SafariServices

class FeedCollectionController: CollectionController, UINavigationControllerDelegate {
    let store = SubredditStore()
    let slideTransition: SlideTransition
    
    var context: ASBatchContext? = nil
    var randomController: UIViewController? = nil
    var name: String? = nil
    
    lazy var menuController: UIViewController = {
        let pageController = SubscriptionsPagerController()
        let controller = ASNavigationController(rootViewController: pageController)
        pageController.delegate = self
        return controller
    }()
    
    init(name: String? = nil) {
        self.slideTransition = SlideTransition(duration: 0.20)
        super.init()
        store.delegate = self
        definesPresentationContext = true
        navigationController?.delegate = transition
        self.name = name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StatusBar.set(color: .clear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        StatusBar.set(color: .clear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.toolbar.backgroundColor = .white
        navigationController?.toolbar.barTintColor = .white
        navigationController?.toolbar.isTranslucent = false
        navigationController?.isToolbarHidden = false
        
        self.slideTransition.mainController = self.navigationController!
        self.slideTransition.menuController = menuController
        
        node.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more-vertical"), style: .plain, target: self, action: #selector(didTapUser))
        
        let fixedBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedBarButtonItem.width = 40.0
        
        setToolbarItems([
            fixedBarButtonItem,
            UIBarButtonItem(image: #imageLiteral(resourceName: "arrows"), style: .plain, target: self, action: #selector(didTapSort)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "compose"), style: .plain, target: self, action: #selector(didTapCompose)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(didTapSearch)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "cogwheel"), style: .plain, target: self, action: #selector(didTapSettings)),
            fixedBarButtonItem
            ], animated: false)
        
        let colorValue: Float = 200/255
        let tintColor = UIColor(colorLiteralRed: colorValue, green: colorValue, blue: colorValue, alpha: 1.0)
        navigationController?.toolbar.tintColor = tintColor
        navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0)
        
        if let name = self.name {
            self.store.setSubreddit(name: name)
            self.store.fetchListing()
            self.setLeftBarButton(subredditName: name)
        }
    }
    
    func setLeftBarButton(subredditName: String) {
        let color = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 228/255, alpha: 1.0)
        let attributeString = NSMutableAttributedString(string: "r/ \(subredditName)", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBlack),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0)
            ])
        let range = (attributeString.string as NSString).range(of: "r/")
        attributeString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        let textNode = ASTextNode()
        textNode.attributedText = attributeString
        let size = textNode.calculateSizeThatFits(navigationController!.navigationBar.frame.size)
        textNode.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: textNode.view)
    }
    
    func transitionToSubreddit(name: String, source: SubredditStore.FeedSource = .subreddit) {
        self.models = []
        self.name = name
        UIView.transition(with: self.navigationController!.view, duration: 0.50, options: [.transitionFlipFromRight], animations: nil, completion: nil)
        self.setLeftBarButton(subredditName: "")
        self.updateModels(completion: { (success) in
            self.setLeftBarButton(subredditName: name)
            self.node.view.contentOffset = CGPoint(x: 0.0, y: 0.0)
            if source == .subreddit {
                self.store.setSubreddit(name: name)
            }
            if source == .frontpage {
                self.store.setSubreddit(name: "", source: .frontpage)
            }
            self.store.fetchListing()
        })
    }
    
    override func sectionController() -> GenericSectionController {
        let sectionController = InsetSectionController(inset: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        return sectionController
    }
    
    override func fetch(context: ASBatchContext) {
        store.fetchListing()
        self.context = context
    }
    
    override func shouldFetch() -> Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

////////////////////////////////////////
//
//  SEARCH PAGE ACTIONS
//
////////////////////////////////////////

extension FeedCollectionController: SearchPageControllerDelegate {
    func didSelectSubreddit(name: String) {
        self.store.clear()
        self.randomController?.dismiss(animated: true, completion: {
            self.transitionToSubreddit(name: name)
        })
    }
}

////////////////////////////////////////
//
//  SUBREDDIT STORE DELEGATE
//
////////////////////////////////////////

extension FeedCollectionController: SubredditStoreDelegate {
    func didUpdateSubreddit(subreddit: Subreddit) {
//        self.setLeftBarButton(subredditName: subreddit.displayName)
    }
    
    func didUpdatePosts(submissions: List<Submission>) {
        self.models = submissions.map({ (submission) -> PostViewModel in
            let post = PostViewModel(submission: submission)
            post.delegate = self
            return post
        })
        self.updateModels()
        guard let context = context else { return }
        context.completeBatchFetching(true)
        self.context = nil
    }
    
    func didSetToFrontpage() {
        self.setLeftBarButton(subredditName: "Frontpage")
    }
    
    func didClear() {}
}

////////////////////////////////////////
//
//  SUBSCRIPTIONS SIDE BAR MENU ACTIONS
//
////////////////////////////////////////

extension FeedCollectionController: SubscriptionsPagerControllerDelegate {
    func didSelectSubreddit(subreddit: SubredditListItemViewModel) {
        self.store.clear()
        menuController.dismiss(animated: true, completion: {
            self.transitionToSubreddit(name: subreddit.name)
        })
        self.slideTransition.finish()
    }
    func didSelectFrontpage() {
        self.store.clear()
        menuController.dismiss(animated: true, completion: {
            self.transitionToSubreddit(name: "Frontpage", source: .frontpage)
        })
        self.slideTransition.finish()
    }
}

////////////////////////////////////////
//
//  POST SUBMISSION ACTIONS
//
////////////////////////////////////////

extension FeedCollectionController: PostViewModelDelegate {
    func didSelectPost(post: PostViewModel) {
        let transition = CoverTransition(duration: 0.25, delay: 0.1)
        transition.automaticallyManageGesture = true
        let articleController = ArticleCollectionController(id: post.id)
        articleController.store.setSubmission(id: post.id)
        articleController.store.fetchComments()
        let controller = NavigationController(rootViewController: articleController)
        controller.isToolbarHidden = true
        controller.isNavigationBarHidden = true
        controller.transition = transition
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func didTapLink(post: PostViewModel) {
        do {
            let realm = try Realm()
            let submission = realm.object(ofType: Submission.self, forPrimaryKey: post.id)
            guard let guardedSubmission = submission, let url = guardedSubmission.urlOrigin else { return }
            transition = nil
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
    func didTapComments(post: PostViewModel) {
        transition = CardTransition(duration: 0.25)
        if let transition = transition as? CardTransition {
            transition.automaticallyManageGesture = true
            transition.cardHeight = 0.9
            transition.overlayAlpha = 0.9
            transition.scaleValue = 1.0
        }
        let commentController = CommentCollectionController()
        commentController.store.fetchComments(submissionId: post.id, sort: .hot)
        commentController.collectionNode.view.bounces = false
        commentController.title = "Comments"
        let controller = ASNavigationController(rootViewController: commentController)
        controller.transitioningDelegate = transition
        controller.navigationBar.barTintColor = .white
        controller.navigationBar.frame.size = CGSize(width: node.frame.width, height: 120.0)
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapMedia(post: PostViewModel, index: Int) {
        let sectionIndex = models.index { (model) -> Bool in
            guard let model = model as? PostViewModel else { return false }
            return model.id == post.id
        }
        
        guard let guardedSectionIndex = sectionIndex else { return }
        
        let postCellIndexPath = IndexPath(item: 0, section: guardedSectionIndex)
        guard let postCell = collectionNode.nodeForItem(at: postCellIndexPath) as? CellNodePost, let albumCell = postCell.mediaView as? CellNodeMediaAlbum, let postLayout = collectionNode.collectionViewLayout.layoutAttributesForItem(at: postCellIndexPath) else { return }
        
        let postLocation = self.collectionNode.convert(postLayout.frame, to: self.collectionNode)
        
        let mediaCellIndexPath = IndexPath(row: index, section: 0)
        guard let mediaCell = albumCell.collectionNode.nodeForItem(at: mediaCellIndexPath) as? CellNodeMedia else { return }
        guard let selectedMediaCellLayout = albumCell.collectionNode.collectionViewLayout.layoutAttributesForItem(at: mediaCellIndexPath) else { return }
        
        let xOrigin: CGFloat = selectedMediaCellLayout.frame.origin.x - albumCell.collectionNode.view.contentOffset.x
        let yOrigin: CGFloat = postLocation.origin.y + postCell.mediaView!.frame.origin.y - self.collectionNode.view.contentOffset.y
        let origin = CGRect(x: xOrigin, y: yOrigin, width: selectedMediaCellLayout.frame.width, height: selectedMediaCellLayout.frame.height)
        
        let height = aspectHeight(self.collectionNode.frame.size, mediaCell.frame.size)
        let destination: CGRect = CGRect(x: 0, y: 0, width: node.frame.width, height: height)
        
        transition = FrameTransition(duration: 0.8, delay: 1.0, origin: origin, destination: destination, node: mediaCell)
        
        let controller = MediaCollectionController(media: post.media)
        controller.transitioningDelegate = transition
        controller.startingIndex = index
        
        if let videoMedia = mediaCell.mediaView as? ASVideoNode {
            if let currentTime = videoMedia.currentItem?.currentTime() {
                controller.startingTime = currentTime
            }
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func didUpvote(post: PostViewModel) {
        store.upvote(id: post.id)
    }
    
    func didDownvote(post: PostViewModel) {
        store.downvote(id: post.id)
    }
    
    func didSave(post: PostViewModel) {
        store.save(id: post.id)
    }
    
    func didUnsave(post: PostViewModel) {
        store.unsave(id: post.id)
    }
    
    func didUnvote(post: PostViewModel) {
        store.unvote(id: post.id)
    }
}

////////////////////////////////////////
//
//  TAB BAR ACTIONS
//
////////////////////////////////////////

extension FeedCollectionController {
    func didTapSort() {
        let transition = CardTransition(duration: 0.25)
        transition.automaticallyManageGesture = true
        transition.overlayAlpha = 0.9
        transition.scaleValue = 1.0
        
        let controller = CollectionController()
        controller.transition = transition
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkText,
            NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        ]
        
        let hot = NSMutableAttributedString(string: "Sort by Hot", attributes: attributes)
        let new = NSMutableAttributedString(string: "Sort by New", attributes: attributes)
        let rising = NSMutableAttributedString(string: "Sort by Rising", attributes: attributes)
        let top = NSMutableAttributedString(string: "Sort by Top", attributes: attributes)
        let cancel = NSMutableAttributedString(string: "Cancel", attributes: attributes)
        
        let itemHot = MenuItemViewModel(image: #imageLiteral(resourceName: "burn"), text: hot, didSelect: {
            self.models = []
            self.updateModels(animated: true) { (success) in
                self.store.setSort(sort: .hot)
            }
            controller.dismiss(animated: true, completion: nil)
            controller.transition?.finish()
        })
        let itemNew = MenuItemViewModel(image: #imageLiteral(resourceName: "new"), text: new, didSelect: {
            self.models = []
            self.updateModels(animated: true) { (success) in
                self.store.setSort(sort: .new)
            }
            controller.dismiss(animated: true, completion: nil)
            controller.transition?.finish()
        })
        let itemRising = MenuItemViewModel(image: #imageLiteral(resourceName: "analytics"), text: rising, didSelect: {
            self.models = []
            self.updateModels(animated: true) { (success) in
                self.store.setSort(sort: .rising)
            }
            controller.dismiss(animated: true, completion: nil)
            controller.transition?.finish()
        })
        let itemTop = MenuItemViewModel(image: #imageLiteral(resourceName: "favorite"), text: top, didSelect: {
            self.models = []
            self.updateModels(animated: true) { (success) in
                self.store.setSort(sort: .top)
            }
            controller.dismiss(animated: true, completion: nil)
            controller.transition?.finish()
        })
        let itemCancel = MenuItemViewModel(image: #imageLiteral(resourceName: "close"), text: cancel, didSelect: {
            controller.dismiss(animated: true, completion: nil)
            controller.transition?.finish()
        })
        
        controller.models = [itemHot, itemNew, itemRising, itemTop, itemCancel]
        
        transition.cardDimension = ASDimension(unit: .points, value: (CGFloat(controller.models.count) * 50.0 + 15.0))
        
        controller.updateModels(animated: false)
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapCompose() {
        
    }
    
    func didTapSettings() {
        let transition = CardTransition(duration: 0.25)
        transition.automaticallyManageGesture = true
        transition.overlayAlpha = 0.9
        transition.scaleValue = 1.0
        
        let controller = CollectionController()
        controller.transition = transition
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkText,
            NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        ]
        
        let rules = NSMutableAttributedString(string: "Rules", attributes: attributes)
        let favorite = NSMutableAttributedString(string: "Favorite", attributes: attributes)
        let unfavorite = NSMutableAttributedString(string: "Unfavorite", attributes: attributes)
        let multireddit = NSMutableAttributedString(string: "Add to Multireddit", attributes: attributes)
        let resize = NSMutableAttributedString(string: "Resize Posts", attributes: attributes)
        let subscribe = NSMutableAttributedString(string: "Subscribe to Subreddit", attributes: attributes)
        let unsubscribe = NSMutableAttributedString(string: "Unsubscribe from Subreddit", attributes: attributes)
        let cancel = NSMutableAttributedString(string: "Cancel", attributes: attributes)
        
        let itemRules = MenuItemViewModel(image: #imageLiteral(resourceName: "rules"), text: rules, didSelect: {})
        let itemMultireddit = MenuItemViewModel(image: #imageLiteral(resourceName: "multireddit"), text: multireddit, didSelect: {})
        let itemResize = MenuItemViewModel(image: #imageLiteral(resourceName: "resize"), text: resize, didSelect: {})
        var itemSubscribe: MenuItemViewModel
        var itemFavorite: MenuItemViewModel
        if self.store.isSubscribed() {
            itemSubscribe = MenuItemViewModel(image: #imageLiteral(resourceName: "minus"), text: unsubscribe, didSelect: {
                self.store.unsubscribe()
                controller.dismiss(animated: true, completion: nil)
                controller.transition?.finish()
            })
        } else {
            itemSubscribe = MenuItemViewModel(image: #imageLiteral(resourceName: "plus"), text: subscribe, didSelect: {
                self.store.subscribe()
                controller.dismiss(animated: true, completion: nil)
                controller.transition?.finish()
            })
        }
                
        if self.store.isFavorited() {
            itemFavorite = MenuItemViewModel(image: #imageLiteral(resourceName: "favorite-delete"), text: unfavorite, didSelect: {
                self.store.unfavorite()
                controller.dismiss(animated: true, completion: nil)
                controller.transition?.finish()
            })
        } else {
            itemFavorite = MenuItemViewModel(image: #imageLiteral(resourceName: "favorite-add"), text: favorite, didSelect: {
                self.store.favorite()
                controller.dismiss(animated: true, completion: nil)
                controller.transition?.finish()
            })
        }
        
        let itemCancel = MenuItemViewModel(image: #imageLiteral(resourceName: "close"), text: cancel, didSelect: {
            controller.dismiss(animated: true, completion: nil)
            controller.transition?.finish()
        })
        
        controller.models = self.store.isSubreddit() ? [itemRules, itemFavorite, itemMultireddit, itemResize, itemSubscribe, itemCancel] : [itemResize, itemCancel]
        
        transition.cardDimension = ASDimension(unit: .points, value: (CGFloat(controller.models.count) * 50.0 + 15.0))
        
        controller.updateModels(animated: false)
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapMedia() {
        transition = CardTransition(duration: 0.25)
        if let transition = transition as? CardTransition {
            transition.automaticallyManageGesture = true
        }
        let controller = MenuUserProfileController()
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapSearch() {
        let searchController = SearchController()
        searchController.delegate = self
        let controller = ASNavigationController(rootViewController: searchController)
        self.randomController = controller
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapUser() {
        let controller = menuController
        controller.transitioningDelegate = slideTransition
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
}

