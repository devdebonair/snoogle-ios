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
        let color = UIColor(colorLiteralRed: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
        let attributeString = NSMutableAttributedString(string: titleHeader.capitalized, attributes: [
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
}
