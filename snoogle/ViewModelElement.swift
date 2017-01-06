//
//  ViewModelElement.swift
//  snoogle
//
//  Created by Vincent Moore on 1/4/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

protocol ViewModelElement {
    func numberOfCells() -> Int
    func cellAtRow(indexPath: IndexPath) -> ASCellNode
}
