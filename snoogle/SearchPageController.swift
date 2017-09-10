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

protocol SearchPageControllerDelegate {
    func didSelectSubreddit(name: String)
}

class SearchPageController: ASViewController<ASDisplayNode>, SearchStoreDelegate {
    let pager: NodePager
    let store = SearchStore()
    let term: String
    
    var delegate: SearchPageControllerDelegate? = nil
    var randomController: NavigationController? = nil
    
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
        self.term = term
        self.pager = NodePager()
        super.init(node: self.pager)
        self.pager.delegate = self
        self.store.delegate = self
        self.store.set(term: term, time: .week)
        self.title = term.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
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
                let model = SubredditListItemViewModel(name: subreddit.displayName, subtitle: subreddit.publicDescriptionStripped, imageUrl: subreddit.urlValidImage)
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
    
    func clearResults() {
        if let allController = controllers[.all] as? SearchAllController {
            allController.updateModels(models: [])
        }
        if let subredditController = controllers[.subreddits] as? SearchSubredditController {
            subredditController.updateModels(models: [])
        }
        if let subredditController = controllers[.discussions] as? SearchSubredditController {
            subredditController.updateModels(models: [])
        }
        if let photoController = controllers[.photos] as? SearchPhotoCollectionController {
            photoController.models = []
            photoController.updateModels()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchPhotos()
        store.fetchSubreddits()
        store.fetchDiscussions()
        
        node.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "arrow-left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "arrow-left")
        
        navigationController?.toolbar.isTranslucent = false
        navigationController?.toolbar.barTintColor = .white
        
        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            createToolBarButton(text: "All", selector: #selector(didTapAll)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            createToolBarButton(text: "Hour", selector: #selector(didTapHour)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            createToolBarButton(text: "Week", selector: #selector(didTapWeek)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            createToolBarButton(text: "Day", selector: #selector(didTapDay)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            createToolBarButton(text: "Month", selector: #selector(didTapMonth)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            createToolBarButton(text: "Year", selector: #selector(didTapYear)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        ], animated: false)
        
        selectBarItem(time: .week)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: nil)
        
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
    }
    
    func createToolBarButton(text: String, selector: Selector? = nil) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: text, style: .plain, target: self, action: selector)
        return button
    }
    
    fileprivate func selectBarItem(time: SearchTimeType) {
        guard let items = self.toolbarItems else { return }
        for item in items {
            if let title = item.title {
                let type = SearchTimeType(rawValue: title.lowercased())
                if type == time {
                    item.setTitleTextAttributes([
                        NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold),
                        NSForegroundColorAttributeName: UIColor(colorLiteralRed: 44/255, green: 45/255, blue: 48/255, alpha: 1.0)
                    ], for: [])
                } else {
                    item.setTitleTextAttributes([
                        NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold),
                        NSForegroundColorAttributeName: UIColor(colorLiteralRed: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
                    ], for: [])
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.tintColor = .darkText
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.isToolbarHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchPageController {
    func didTapAll() {
        guard self.store.time != .all else { return }
        selectBarItem(time: .all)
        self.clearResults()
        self.store.set(term: term, time: .all)
        self.store.fetchPhotos()
        self.store.fetchSubreddits()
        self.store.fetchDiscussions()
    }
    
    func didTapHour() {
        guard self.store.time != .hour else { return }
        selectBarItem(time: .hour)
        self.clearResults()
        self.store.set(term: term, time: .hour)
        self.store.fetchPhotos()
        self.store.fetchSubreddits()
        self.store.fetchDiscussions()
    }
    
    func didTapDay() {
        guard self.store.time != .day else { return }
        selectBarItem(time: .day)
        self.clearResults()
        self.store.set(term: term, time: .day)
        self.store.fetchPhotos()
        self.store.fetchSubreddits()
        self.store.fetchDiscussions()
    }
    
    func didTapWeek() {
        guard self.store.time != .week else { return }
        selectBarItem(time: .week)
        self.clearResults()
        self.store.set(term: term, time: .week)
        self.store.fetchPhotos()
        self.store.fetchSubreddits()
        self.store.fetchDiscussions()
    }
    
    func didTapMonth() {
        guard self.store.time != .month else { return }
        selectBarItem(time: .month)
        self.clearResults()
        self.store.set(term: term, time: .month)
        self.store.fetchPhotos()
        self.store.fetchSubreddits()
        self.store.fetchDiscussions()
    }
    
    func didTapYear() {
        guard self.store.time != .year else { return }
        selectBarItem(time: .year)
        self.clearResults()
        self.store.set(term: term, time: .year)
        self.store.fetchPhotos()
        self.store.fetchSubreddits()
        self.store.fetchDiscussions()
    }
}

extension SearchPageController: SubredditListItemViewModelDelegate, SubredditListGroupViewModelDelegate {
    func didSelectSubreddit(subreddit: SubredditListItemViewModel) {
        let transition = CoverTransition(duration: 0.25, delay: 0.1)
        transition.automaticallyManageGesture = true
        let subredditPageController = SubredditPageCollectionController(name: subreddit.name)
        subredditPageController.delegate = self
        let controller = NavigationController(rootViewController: subredditPageController)
        controller.transition = transition
        controller.isToolbarHidden = true
        controller.isNavigationBarHidden = true
        self.randomController = controller
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    func didSelectMoreSubreddits() {
        guard let index = pageOrder.index(of: .subreddits) else { return }
        self.pager.scrollToPage(at: index, animated: true)
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
        self.pager.scrollToPage(at: index, animated: true)
    }
}

extension SearchPageController: NodePagerDelegate {
    func pager(didScroll: ASPagerNode) {}
    func pager(didScrollToPage index: Int, pager: ASPagerNode) {}
    
    func numberOfPages() -> Int {
        return pageOrder.count
    }
    
    func pager(controllerAtIndex index: Int) -> UIViewController {
        let page = controllers[pageOrder[index]]
        guard let guardedPage = page else { return UIViewController() }
        return guardedPage
    }
}

extension SearchPageController: SubredditPageCollectionControllerDelegate {
    func didTapBrowse(name: String) {
        guard let delegate = delegate else { return }
        self.randomController?.dismiss(animated: true, completion: {
            delegate.didSelectSubreddit(name: name)
        })
        randomController?.transition?.finish()
    }
}
