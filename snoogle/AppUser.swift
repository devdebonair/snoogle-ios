//
//  AppUser.swift
//  snoogle
//
//  Created by Vincent Moore on 8/7/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

class AppUser: Object {
    var activeAccount: Account?
    var accounts = List<Account>()
    var subredditRecent = List<Subreddit>()
    var subredditFavorites = List<Subreddit>()
}
