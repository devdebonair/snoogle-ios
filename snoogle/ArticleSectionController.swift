//
//  ArticleSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 4/1/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class ArticleSectionController: SectionController<ArticleViewModel> {
    
    override func didSelectItem(at index: Int) {
        print("selected photo: \(model.primaryKey())")
    }
}
