//
//  PostViewModel+Submission.swift
//  snoogle
//
//  Created by Vincent Moore on 5/15/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

extension PostViewModel {
    convenience init(submission: Submission, shouldShowSub: Bool = false) {
        var media = [MediaElement]()
        for item in submission.media {
            guard let guardedType = item.mediaType else { continue }
            switch guardedType {
            case .photo:
                let toInsert = Photo(width: item.width, height: item.height, url: item.urlOrigin, urlSmall: item.urlSmall, urlMedium: item.urlMedium, urlLarge: item.urlLarge, urlHuge: item.urlHuge, info: item.info)
                media.append(toInsert)
            case .video:
                let toInsert = Video(width: item.width, height: item.height, url: item.urlOrigin, poster: item.urlPoster, gif: item.urlGif, info: item.info)
                media.append(toInsert)
            case .movie:
                let toInsert = Movie()
                toInsert.height = item.height
                toInsert.width = item.width
                toInsert.title = item.title
                toInsert.url = item.urlOrigin
                toInsert.poster = item.urlPoster
                toInsert.info  = item.info
                toInsert.logo = item.logo
                toInsert.author = item.author
                media.append(toInsert)
            }
        }
        let meta = shouldShowSub ? submission.meta : submission.metaIgnoreSub
        self.init(id: submission.id, meta: meta, title: submission.title, info: submission.selftextTruncated.trimmingCharacters(in: .newlines), media: media, numberOfComments: submission.numComments, isSticky: submission.stickied, vote: submission.vote, saved: submission.saved, hint: submission.hint, domain: submission.domain)
        if media.count == 1, let _ = media.first as? Movie {
            self.hint = .movie
        }
        if !submission.linkFlairText.isEmpty {
            let tagItem = TagViewModel()
            tagItem.text = submission.linkFlairText.uppercased()
            tagItem.colorText = UIColor(colorLiteralRed: 51/255, green: 102/255, blue: 153/255, alpha: 1.0)
            tagItem.colorBackground = UIColor(colorLiteralRed: 206/255, green: 227/255, blue: 248/255, alpha: 1.0)
            self.tags.append(tagItem)
        }
        if submission.isNSFW {
            let tagItem = TagViewModel()
            tagItem.text = "NSFW"
            tagItem.colorText = UIColor(colorLiteralRed: 51/255, green: 102/255, blue: 153/255, alpha: 1.0)
            tagItem.colorBackground = UIColor(colorLiteralRed: 206/255, green: 227/255, blue: 248/255, alpha: 1.0)
            self.tags.append(tagItem)
        }
    }
}
