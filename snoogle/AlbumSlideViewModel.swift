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
    
    func cell() -> ASCellNode {
        let cell = CellNodeMedia(media: media)
        cell.mediaView.borderColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0).cgColor
        cell.mediaView.cornerRadius = 5.0
        cell.mediaView.clipsToBounds = true
        cell.mediaView.borderWidth = 0.5
        return cell
    }
}
