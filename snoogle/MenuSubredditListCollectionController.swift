//
//  MenuSubredditListCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 6/2/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class MenuSubredditListCollectionController: MenuItemCollectionController {
    override init() {
        super.init()
        self.models = [
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
            MenuSubredditListViewModel(title: "Haikyuu!!!", subtitle: "1,000,000 Subscribers", url: URL(string: "https://s-media-cache-ak0.pinimg.com/736x/cb/5d/e6/cb5de6cb47316257345fe4d9c3f2ca58.jpg")),
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
