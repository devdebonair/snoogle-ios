//
//  SubredditListCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 6/24/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class SubredditListItemController: CollectionController {
    override init() {
        super.init()
        self.models = [
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            SubredditListItemViewModel(name: "Haikyuu!!!", subscribers: 100000, imageUrl: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg"))
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = navigationController else { return }
        let color = UIColor(colorLiteralRed: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
        let attributeString = NSMutableAttributedString(string: "Recent Subreddits", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
            NSForegroundColorAttributeName: color
        ])
        
        let textNode = ASTextNode()
        textNode.attributedText = attributeString
        let size = textNode.calculateSizeThatFits(navigationController.navigationBar.frame.size)
        textNode.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: textNode.view)
        navigationController.toolbar.barTintColor = navigationController.navigationBar.barTintColor
        self.node.backgroundColor = navigationController.navigationBar.barTintColor
        navigationController.toolbar.isTranslucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SubredditListItemSectionController()
    }
}
