//
//  CommentViewModel+Comment.swift
//  snoogle
//
//  Created by Vincent Moore on 5/16/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

extension CommentViewModel {
    convenience init(comments: List<Comment>) {
        var mappedComments = [StructComment]()
        for comment in comments {
            let toAppend = StructComment(id: comment.id, meta: comment.meta, body: comment.body, level: comment.level)
            mappedComments.append(toAppend)
        }
        self.init(comments: mappedComments)
    }
}
