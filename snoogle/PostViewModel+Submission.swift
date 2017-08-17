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
    convenience init(submission: Submission) {
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
            }
        }
        self.init(id: submission.id, meta: submission.metaIgnoreSub, title: submission.title, info: submission.selftextTruncated, media: media, numberOfComments: submission.numComments, isSticky: submission.stickied, vote: submission.vote, saved: submission.saved, hint: submission.hint, domain: submission.domain)
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
            tagItem.colorText = .white
            tagItem.colorBackground = UIColor(colorLiteralRed: 45/255, green: 46/255, blue: 48/255, alpha: 1.0)
            self.tags.append(tagItem)
        }
    }
}
