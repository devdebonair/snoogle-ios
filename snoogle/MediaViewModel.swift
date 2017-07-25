//
//  MediaViewModel.swift
//  snoogle
//
//  Created by Vincent Moore on 7/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift
import AsyncDisplayKit

class MediaViewModel: NSObject, ViewModelElement {
    
    let media: MediaElement
    
    init(media: MediaElement) {
        self.media = media
    }

    func numberOfCells() -> Int {
        return 1
    }
    
    func cell(index: Int) -> ASCellNode {
        return CellNodeMedia(media: media)
    }
    
}
