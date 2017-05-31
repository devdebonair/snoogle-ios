//
//  SubmissionSortSectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 5/29/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

class SubmissionSortSectionController: SectionController {
    
    var sortSelection: SubmissionSortViewModel { return model as! SubmissionSortViewModel }
    
    override func didSelectItem(at index: Int) {
        print("selected an item")
    }
    
}
