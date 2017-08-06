//
//  SubredditPageGroupViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 8/3/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class SubredditPageGroupViewModel: NSObject, ViewModelElement {
    func numberOfCells() -> Int {
        return 0
    }
    
    func cell(index: Int) -> ASCellNode {
        return ASCellNode()
    }
}
