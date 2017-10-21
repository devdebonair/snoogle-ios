//
//  ThemePickerController.swift
//  snoogle
//
//  Created by Vincent Moore on 10/16/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RealmSwift

class ThemePickerController: CollectionController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTheme))
        do {
            let realm = try Realm()
            let themes = realm.objects(Theme.self)
            let themeModels = themes.map({ (theme) -> SettingsTextViewModel in
                let model = SettingsTextViewModel()
                model.text = theme.name
                model.didSelect = { [weak self] in
                    let controller = ThemeEditorController(name: theme.name)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
                return model
            })
            self.models = Array(themeModels)
            self.updateModels()
        } catch {
            print(error)
        }
    }
    
    func addTheme() {
        let controller = ThemeEditorController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
