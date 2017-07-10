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

class FeedCollectionController: CollectionController, UINavigationControllerDelegate, SubredditStoreDelegate {
    
    var transition: Transition!
    let TOOLBAR_HEIGHT: CGFloat = 49
    let slideTransition: SlideTransition
    var context: ASBatchContext? = nil
    
    let store = SubredditStore()
    
    lazy var menuController: UIViewController = {
        let controller = ASNavigationController(rootViewController: SubscriptionsPagerController())
        return controller
    }()
    
    override init() {
        self.slideTransition = SlideTransition(duration: 0.20)
        
        super.init()
        
        store.delegate = self
        
        definesPresentationContext = true
        navigationController?.delegate = transition
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StatusBar.set(color: .clear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        StatusBar.set(color: .white)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "user"), style: .plain, target: self, action: #selector(didTapUser))
        
        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "arrows"), style: .plain, target: self, action: #selector(didTapSort)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "photo"), style: .plain, target: self, action: #selector(didTapMedia)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "compose"), style: .plain, target: self, action: #selector(didTapCompose)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(didTapSearch)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: #imageLiteral(resourceName: "cogwheel"), style: .plain, target: self, action: #selector(didTapSettings)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            ], animated: false)
    }
    
    func setLeftBarButton(subredditName: String) {
        let color = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 228/255, alpha: 1.0)
        let attributeString = NSMutableAttributedString(string: "r/ \(subredditName)", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBlack)
            ])
        let range = (attributeString.string as NSString).range(of: "r/")
        attributeString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        let textNode = ASTextNode()
        textNode.attributedText = attributeString
        let size = textNode.calculateSizeThatFits(navigationController!.navigationBar.frame.size)
        textNode.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: textNode.view)
    }
    
    func didUpdatePosts(submissions: List<Submission>) {
        self.models = submissions.map({ (submission) -> PostViewModel in
            return PostViewModel(submission: submission)
        })
        self.adapter.performUpdates(animated: true, completion: nil)
        guard let context = context else { return }
        context.completeBatchFetching(true)
        self.context = nil
    }
    
    func didUpdateSubreddit(subreddit: Subreddit) {
        self.setLeftBarButton(subredditName: subreddit.displayName)
    }
    
    override func shouldFetch() -> Bool {
        return true
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SubmissionSectionController()
    }
    
    override func fetch(context: ASBatchContext) {
        store.fetchListing()
        self.context = context
    }
    
    func didTapSort() {
        transition = CardTransition(duration: 0.25)
        if let transition = transition as? CardTransition {
            transition.automaticallyManageGesture = true
        }
        let controller = MenuItemSortController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapCompose() {
        transition = CardTransition(duration: 0.25)
        if let transition = transition as? CardTransition {
            transition.automaticallyManageGesture = true
        }
        let controller = MenuItemComposeController()
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapSettings() {
        transition = CardTransition(duration: 0.25)
        if let transition = transition as? CardTransition {
            transition.automaticallyManageGesture = true
        }
        let controller = MenuItemSubredditSettingsController()
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
        transition = CardTransition(duration: 0.25)
        if let transition = transition as? CardTransition {
            transition.automaticallyManageGesture = true
        }
        let controller = MenuSubredditListCollectionController()
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapUser() {
        let controller = menuController
        controller.transitioningDelegate = slideTransition
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
