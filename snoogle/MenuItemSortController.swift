//
//  MenuItemSortController.swift
//  snoogle
//
//  Created by Vincent Moore on 5/31/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import IGListKit

protocol MenuItemSortControllerDelegate {
    func didSelectSort(sort: ListingSort)
}

class MenuItemSortController: MenuItemCollectionController, SubmissionSortViewModelDelegate {
    
    var delegate: MenuItemSortControllerDelegate? = nil
    
    override init() {
        super.init()
        let submissionSortModel = SubmissionSortViewModel()
        submissionSortModel.delegate = self
        self.models = [submissionSortModel]
    }
    
    func didSelectSort(sort: ListingSort) {
        DispatchQueue.main.async {
            guard let delegate = self.delegate else { return }
            delegate.didSelectSort(sort: sort)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
