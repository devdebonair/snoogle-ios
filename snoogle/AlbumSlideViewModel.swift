//
//  AlbumSlideViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 1/12/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

struct AlbumSlideViewModel: ViewModelElement {
    
    let media: [MediaElement]
    
    func numberOfCells() -> Int {
        return 1
    }
    
    func cellAtRow(indexPath: IndexPath) -> ASCellNode {
        return CellNodeMedia(media: media)
    }
}
