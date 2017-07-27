//
//  MultipleMediaViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MultipleMediaViewModel: NSObject, ViewModelElement {
    let models: [MediaViewModel]
    
    init(models: [MediaViewModel]) {
        self.models = models
    }
    
    func numberOfCells() -> Int {
        return models.count
    }
    
    func cell(index: Int) -> ASCellNode {
        return models[index].cell(index: 0)
    }
}
