//
//  ArticleViewModel+Submission.swift
//  snoogle
//
//  Created by Vincent Moore on 5/15/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit

extension ArticleViewModel {
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
            case .movie:
                let movie = Movie()
                movie.height = item.height
                movie.width = item.width
                movie.title = item.title
                movie.url = item.urlOrigin
                movie.poster = item.urlPoster
                movie.info = item.info
                media.append(movie)
            }
        }
        self.init(author: submission.authorName, origin: "r/ \(submission.subredditName)", created: submission.created, title: submission.title, media: media, content: submission.selftextComponents, vote: submission.vote, saved: submission.saved, numberOfComments: submission.numComments)
        
        for item in submission.articleComponents {
            let paragraphStyleDescription = NSMutableParagraphStyle()
            paragraphStyleDescription.lineSpacing = 6.0
            let attributesToAdd: [String:Any] = [
                NSParagraphStyleAttributeName: paragraphStyleDescription,
                NSForegroundColorAttributeName: ThemeManager.textPrimary()
            ]
            let font = UIFont(name: "Charter", size: 17)!
            let block = MarkdownBuilder(customAttributes: attributesToAdd).parseComponent(component: item, font: font)
            if let block = block {
                self.newContent.append(block)
            }
        }
    }
}
