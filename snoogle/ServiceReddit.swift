//
//  ServiceReddit.swift
//  snoogle
//
//  Created by Vincent Moore on 8/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import KeychainSwift

class ServiceReddit: Service {
    let HEADER_TOKEN_ACCESS = "AccessToken"
    let HEADER_TOKEN_REFRESH = "RefreshToken"
    let user: String
    
    init(user: String) {
        self.user = user
        super.init()
    }
    
    func oauthRequest() -> Network? {
        let keychain = KeychainSwift(keyPrefix: self.user.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
        guard let accessToken = keychain.get("access_token"), let refreshToken = keychain.get("refresh_token") else { return nil }
        return Network().header(add: HEADER_TOKEN_ACCESS, value: accessToken).header(add: HEADER_TOKEN_REFRESH, value: refreshToken)
    }
}
