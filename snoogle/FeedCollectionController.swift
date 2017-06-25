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

class FeedCollectionController: CollectionController, UINavigationControllerDelegate {
    
    let name: String
    let sort: ListingSort
    var listing: ListingSubreddit? = nil
    var transition: Transition!
    let TOOLBAR_HEIGHT: CGFloat = 49
    var token: NotificationToken? = nil
    let slideTransition: SlideTransition
    
    var menuController: ASNavigationController {
        let color = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        let navigationBarColor = UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1.0)
        let controller = ASNavigationController(rootViewController: SubredditListItemController())
        controller.navigationBar.isTranslucent = false
        controller.navigationBar.barTintColor = navigationBarColor
        controller.view.backgroundColor = color
        return controller
    }
    
    var leftBarItem: UIView = UIView() {
        didSet {
           self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItem)
        }
    }
    
    var sub: Subreddit? = nil {
        didSet {
            // Set the name of the Subreddit on the navigation bar
            guard let guardedSub = sub else { return }
            self.setLeftBarButton(subredditName: guardedSub.displayName)
        }
    }

    init(name: String, sort: ListingSort = .hot) {
        self.name = name
        self.sort = sort
        self.slideTransition = SlideTransition(duration: 0.20)
        
        super.init()
        
        DispatchQueue.main.async {
            self.loadListing()
        }
        
        definesPresentationContext = true
        navigationController?.delegate = transition
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let sub = sub {
            setLeftBarButton(subredditName: sub.displayName)
        }
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
        
        ServiceSubreddit(name: name).listing(sort: sort) { success in
            if success {
                DispatchQueue.main.async {
                    self.loadListing()
                }
            }
        }
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
        
        leftBarItem = textNode.view
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
            return PostViewModel(submission: submission)
        })
        self.adapter.performUpdates(animated: true)
    }
    
    override func shouldFetch() -> Bool {
        return true
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SubmissionSectionController()
    }
    
    override func fetch(context: ASBatchContext) {
        ServiceSubreddit(name: name).moreListings(sort: sort) { (success: Bool) in
            context.completeBatchFetching(success)
        }
    }
    
    func didTapSort() {
        transition = CardTransition(duration: 0.25)
        let controller = MenuItemSortController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapCompose() {
        transition = CardTransition(duration: 0.25)
        let controller = MenuItemComposeController()
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapSettings() {
        transition = CardTransition(duration: 0.25)
        let controller = MenuItemSubredditSettingsController()
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapMedia() {
        transition = CardTransition(duration: 0.25)
        let controller = MenuUserProfileController()
        controller.transitioningDelegate = transition
        controller.collectionNode.view.bounces = false
        self.navigationController?.present(controller, animated: true)
    }
    
    func didTapSearch() {
        transition = CardTransition(duration: 0.25)
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
