//
//  PostViewModel+Submission.swift
//  snoogle
//
//  Created by Vincent Moore on 5/15/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation

extension PostViewModel {
    convenience init(submission: Submission) {
        var media = [MediaElement]()
        for item in submission.media {
            guard let guardedType = item.mediaType else { continue }
            switch guardedType {
            case .photo:
                let toInsert = Photo(width: item.width, height: item.height, url: item.urlOrigin, urlSmall: item.urlSmall, urlMedium: item.urlMedium, urlLarge: item.urlLarge, info: item.info)
                media.append(toInsert)
            case .video:
                let toInsert = Video(width: item.width, height: item.height, url: item.urlOrigin, poster: item.urlPoster, gif: item.urlGif, info: item.info)
                media.append(toInsert)
            }
        }
        self.init(id: submission.id, meta: submission.metaIgnoreSub, title: submission.title, info: submission.selftextTruncated, media: media, numberOfComments: submission.numComments, isSticky: submission.stickied, vote: submission.vote, saved: submission.saved)
    }
}
