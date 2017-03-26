//
//  User.swift
//  snoogle
//
//  Created by Vincent Moore on 3/17/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    dynamic var isEmployee: Bool = false
    dynamic var isFriend: Bool = false
    dynamic var isSuspended: Bool = false
    dynamic var id: String = ""
    dynamic var isOver18: Bool = false
    dynamic var isGold: Bool = false
    dynamic var isMod: Bool = false
    dynamic var hasVerifiedEMail: Bool = false
    dynamic var linkKarma: Int = 0
    dynamic var inboxCount: Int = 0
    dynamic var hasMail: Int = 0
    dynamic var name: String = ""
    dynamic var created: Double = 0.0
    dynamic var commentKarma: Int = 0
    
    var dateCreated: Date {
        return Date(timeIntervalSince1970: created)
    }
}
