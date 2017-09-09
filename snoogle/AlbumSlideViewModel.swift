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
    var isStyled: Bool = false
    
    func numberOfCells() -> Int {
        return media.count
    }
    
    func cell(index: Int) -> ASCellNode {
        var mediaItem = media[index]
        // Force square aspect ratio for images that may stretch over screen
        if mediaItem.width > mediaItem.height {
            if let item = mediaItem as? Video {
                mediaItem = Video(width: 1, height: 1, url: item.url, poster: item.poster, gif: item.gif, info: item.info)
            }
            if let item = mediaItem as? Photo {
                mediaItem = Photo(width: 1, height: 1, url: item.url, urlSmall: item.urlSmall, urlMedium: item.urlMedium, urlLarge: item.urlLarge, urlHuge: item.urlHuge, info: item.info)
            }
        }
        let cell = CellNodeMedia(media: mediaItem)
        if isStyled {            
            cell.mediaView.borderColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0).cgColor
            cell.mediaView.cornerRadius = 5.0
            cell.mediaView.clipsToBounds = true
            cell.mediaView.borderWidth = 0.5
            cell.mediaView.backgroundColor = UIColor(colorLiteralRed: 223/255, green: 223/255, blue: 227/255, alpha: 1.0)
        }
        return cell
    }
}
