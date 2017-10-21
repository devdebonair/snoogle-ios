//
//  ThemeEditorController.swift
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

class ThemeEditorController: CollectionController {
    
    var theme = Theme() {
        didSet {
            self.navigationBackgroundModel.icon?.backgroundColor = theme.colorNavigation?.getColor()
            self.navigationItemModel.icon?.backgroundColor = theme.colorNavigationItem?.getColor()
            self.toolbarBackgroundModel.icon?.backgroundColor = theme.colorToolbar?.getColor()
            self.toolbarItemModel.icon?.backgroundColor = theme.colorToolbarItem?.getColor()
            self.background.icon?.backgroundColor = theme.backgroundColor?.getColor()
            self.cardBackground.icon?.backgroundColor = theme.colorCellBackground?.getColor()
            self.cardAccessory.icon?.backgroundColor = theme.colorCellAccessory?.getColor()
            self.textPrimary.icon?.backgroundColor = theme.colorTextPrimary?.getColor()
            self.textSecondary.icon?.backgroundColor = theme.colorTextSecondary?.getColor()
        }
    }
    var navigationBackgroundModel: SettingsIconTextViewModel
    var navigationItemModel: SettingsIconTextViewModel
    var toolbarBackgroundModel: SettingsIconTextViewModel
    var toolbarItemModel: SettingsIconTextViewModel
    var background: SettingsIconTextViewModel
    var cardBackground: SettingsIconTextViewModel
    var cardAccessory: SettingsIconTextViewModel
    var textPrimary: SettingsIconTextViewModel
    var textSecondary: SettingsIconTextViewModel
    let name: String?
    
    init(name: String? = nil) {
        self.name = name
        self.navigationBackgroundModel = ThemeEditorController.buildThemeModel(name: "Navigation Background", color: .randomFlat)
        self.navigationItemModel = ThemeEditorController.buildThemeModel(name: "Navigation Item", color: .randomFlat)
        self.toolbarBackgroundModel = ThemeEditorController.buildThemeModel(name: "Toolbar Background", color: .randomFlat)
        self.toolbarItemModel = ThemeEditorController.buildThemeModel(name: "Toolbar Item", color: .randomFlat)
        self.background = ThemeEditorController.buildThemeModel(name: "Background", color: .randomFlat)
        self.cardBackground = ThemeEditorController.buildThemeModel(name: "Card Background", color: .randomFlat)
        self.cardAccessory = ThemeEditorController.buildThemeModel(name: "Card Accessory", color: .randomFlat)
        self.textPrimary = ThemeEditorController.buildThemeModel(name: "Text Primary", color: .randomFlat)
        self.textSecondary = ThemeEditorController.buildThemeModel(name: "Text Secondary", color: .randomFlat)
        
        super.init()
        
        let textViewModel = SettingsTextViewModel()
        textViewModel.text = theme.name
        
        self.models = [textViewModel, navigationBackgroundModel, navigationItemModel, toolbarBackgroundModel, toolbarItemModel, background, cardBackground, cardAccessory, textPrimary, textSecondary]
        
        for model in self.models {
            guard let model = model as? SettingsIconTextViewModel else { continue }
            model.didSelect = { [weak self] model in
                guard let weakSelf = self, let color = model.icon?.backgroundColor else { return }
                let controller = weakSelf.prepareColorPickerController(color: color)
                controller.didChangeColor = { color in
                    model.icon?.backgroundColor = color
                }
                weakSelf.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Theme"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ThemeManager.navigationItem()]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didTapDone))
        
        do {
            if let name = name, let savedTheme = try Theme.get(name: name) {
                self.theme = savedTheme
            } else {
                self.theme = Theme()
                let realm = try Realm()
                let numberOfThemes = realm.objects(Theme.self).count
                theme.name = "Theme \(numberOfThemes+1)"
            }
        } catch {
            print(error)
        }

        self.updateModels()
    }
    
    func didTapDone() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        do {
            let realm = try Realm()
            try realm.write {
                self.theme.colorNavigation = Color.create(color: self.navigationBackgroundModel.icon?.backgroundColor ?? .clear)
                self.theme.colorNavigationItem = Color.create(color: self.navigationItemModel.icon?.backgroundColor ?? .clear)
                self.theme.colorToolbar = Color.create(color: self.toolbarBackgroundModel.icon?.backgroundColor ?? .clear)
                self.theme.colorToolbarItem = Color.create(color: self.toolbarItemModel.icon?.backgroundColor ?? .clear)
                self.theme.backgroundColor = Color.create(color: self.background.icon?.backgroundColor ?? .clear)
                self.theme.colorCellBackground = Color.create(color: self.cardBackground.icon?.backgroundColor ?? .clear)
                self.theme.colorCellAccessory = Color.create(color: self.cardAccessory.icon?.backgroundColor ?? .clear)
                self.theme.colorTextPrimary = Color.create(color: self.textPrimary.icon?.backgroundColor ?? .clear)
                self.theme.colorTextSecondary = Color.create(color: self.textSecondary.icon?.backgroundColor ?? .clear)
                let dictionary = self.theme.dictionaryWithValues(forKeys: ["colorNavigation", "colorNavigationItem", "colorToolbar", "colorToolbarItem", "backgroundColor", "colorCellBackground", "colorCellAccessory", "colorTextPrimary", "colorTextSecondary", "name"])
                realm.create(Theme.self, value: dictionary, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    fileprivate func prepareColorPickerController(color: UIColor?) -> ColorPickerSlideController {
        let controller = ColorPickerSlideController()
        controller.colorNode.backgroundColor = color
        controller.edgesForExtendedLayout = [.top]
        controller.extendedLayoutIncludesOpaqueBars = true
        return controller
    }
    
    static func buildThemeModel(name: String, color: UIColor) -> SettingsIconTextViewModel {
        let model = SettingsIconTextViewModel()
        model.icon = ASDisplayNode()
        model.icon?.backgroundColor = color
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

