//
//  SettingsThemeController.swift
//  snoogle
//
//  Created by Vincent Moore on 10/7/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import Realm
import RealmSwift
import ChameleonFramework

class SettingsThemeController: CollectionController {
    
    init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Create Theme"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.didTapDone))
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ThemeManager.navigationItem()]
        
        self.models = [
            buildModel(name: "Navigation Background", color: .flatLime),
            buildModel(name: "Navigation Item", color: .flatLime),
            buildModel(name: "Toolbar Background", color: .flatLime),
            buildModel(name: "Toolbar Item", color: .flatLime),
            buildModel(name: "Background", color: .flatLime),
            buildModel(name: "Card Background", color: .flatLime),
            buildModel(name: "Card Accessory", color: .flatLime),
            buildModel(name: "Text Primary", color: .flatLime),
            buildModel(name: "Text Secondary", color: .flatLime)
        ]
        
        self.updateModels()
    }
    
    func buildModel(name: String, color: UIColor) -> IGListDiffable {
        let model = SettingsIconTextViewModel()
        model.icon = ASDisplayNode()
        model.icon?.backgroundColor = .randomFlat
        model.textNode.attributedText = NSAttributedString(string: name, attributes: [
            NSForegroundColorAttributeName: ThemeManager.textPrimary(),
            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        ])
        model.spacing = 20
        model.icon?.style.preferredSize = CGSize(width: 30, height: 30)
        model.icon?.cornerRadius = 5.0
        model.icon?.clipsToBounds = true
        model.icon?.borderColor = ThemeManager.cellAccessory().cgColor
        model.icon?.borderWidth = 0.5
        return model
    }
    
    func didTapDone() {
        self.dismiss(animated: true, completion: nil)
    }
}

