//
//  MediaElement+Media.swift
//  snoogle
//
//  Created by Vincent Moore on 7/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

extension Media {
    func getMediaElement() -> MediaElement? {
        guard let guardedType = self.mediaType else { return nil }
        switch guardedType {
        case .photo:
            return Photo(width: self.width, height: self.height, url: self.urlOrigin, urlSmall: self.urlSmall, urlMedium:
                self.urlMedium, urlLarge: self.urlLarge, urlHuge: self.urlHuge, info: self.info)
        case .video:
            return Video(width: self.width, height: self.height, url: self.urlOrigin, poster: self.urlPoster, gif: self.urlGif, info: self.info)
        case .movie:
            let movie = Movie()
            movie.width = self.width
            movie.height = self.height
            movie.url = self.urlOrigin
            movie.poster = self.urlPoster
            movie.info = self.info
            movie.title = self.title
            movie.author = self.author
            movie.logo = self.urlLogo
            return movie
        }
    }
}
