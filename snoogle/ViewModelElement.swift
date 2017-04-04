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
    func cell(index: Int) -> ASCellNode
    func header() -> ASCellNode?
    func footer() -> ASCellNode?
    func headerSize() -> ASSizeRange
    func footerSize() -> ASSizeRange
}

extension ViewModelElement {
    func header() -> ASCellNode? {
        return nil
    }
    
    func footer() -> ASCellNode? {
        return nil
    }
    
    func headerSize() -> ASSizeRange {
        return ASSizeRangeZero
    }
    
    func footerSize() -> ASSizeRange {
        return ASSizeRangeZero
    }
}
