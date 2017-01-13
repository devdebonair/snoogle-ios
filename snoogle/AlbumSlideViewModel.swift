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
        let cell = CellNodeMedia(media: media)
        cell.mediaView.borderColor = UIColor.darkGray.cgColor
        cell.mediaView.cornerRadius = 5.0
        cell.mediaView.clipsToBounds = true
        cell.mediaView.borderWidth = 0.5
        return cell
    }
}
