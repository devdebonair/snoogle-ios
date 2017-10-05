//
//  SubredditListCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 7/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import IGListKit
import AsyncDisplayKit

class SubredditListCollectionController: CollectionController {
    
    private let titleHeader: String
    private let titleLabel = UILabel()
    
    init(title: String) {
        self.titleHeader = title
        super.init()
    }
    
    func updateModels(models: [IGListDiffable]) {
        self.models = models
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationController = navigationController else { return }
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBlack)
        self.titleLabel.text = self.titleHeader.capitalized
        let size = self.titleLabel.sizeThatFits(navigationController.navigationBar.frame.size)
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.titleLabel)
        
        navigationController.toolbar.isTranslucent = false
        
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        
        let bottomInset: CGFloat = (self.navigationController?.toolbar.frame.height ?? 0) + self.bottomLayoutGuide.length + 20
        collectionNode.view.contentInset = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: bottomInset, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTheme() {
        super.setTheme()
        self.titleLabel.textColor = ThemeManager.navigationItem()
    }
    
    override func configureTheme() {
        super.configureTheme()
        self.adapter.reloadData(completion: nil)
    }
}
