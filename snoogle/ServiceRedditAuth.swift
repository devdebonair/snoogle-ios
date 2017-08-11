//
//  ServiceAuth.swift
//  snoogle
//
//  Created by Vincent Moore on 8/10/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import KeychainSwift

class ServiceRedditAuth: Service {
    func fetchTokens(code: String, completion: ((String?)->Void)?) {
        requestTokens(code: code) { (json: [String:Any]?) in
            guard let json = json, let accessToken = json["access_token"] as? String, let refreshToken = json["refresh_token"] as? String, let name = json["name"] as? String else {
                guard let completion = completion else { return }
                return completion(nil)
            }
            let keychainKeyPrefix = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let keychain = KeychainSwift(keyPrefix: keychainKeyPrefix)
            var success: Bool = false
            success = keychain.set(refreshToken, forKey: "refresh_token")
            success = keychain.set(accessToken, forKey: "access_token")
            guard let completion = completion else { return }
            if success { return completion(name) }
            return completion(nil)
        }
    }
    
    func requestTokens(code: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "auth/token", relativeTo: base)!
        Network()
            .get()
            .header(add: "AuthCode", value: code)
            .url(url)
            .parse(type: .json)
            .success() { (data, response) in
                return completion(data as? [String:Any])
            }
            .failure() { _ in
                return completion(nil)
            }
            .error() { _ in
                return completion(nil)
            }
            .sendHTTP()
    }
}
