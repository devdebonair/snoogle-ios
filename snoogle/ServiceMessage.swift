//
//  ServiceMessage.swift
//  snoogle
//
//  Created by Vincent Moore on 3/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceMessage: ServiceReddit {
    let id: String
    
    init(id: String, user: String) {
        self.id = id
        super.init(user: user)
    }
    
    func fetch(completion: ((Bool)->Void)? = nil) {
        requestFetch { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func compose(to: String, subject: String, text: String, completion: ((Bool)->Void)? = nil) {
        requestCompose(to: to, subject: subject, text: text) { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func reply(text: String, completion: ((Bool)->Void)? = nil) {
        requestReply(text: text) { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func delete(completion: ((Bool)->Void)? = nil) {
        requestDelete { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
}

extension ServiceMessage {
    func requestFetch(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "message/\(id)", relativeTo: base)!
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
            .get()
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
    
    func requestCompose(to: String, subject: String, text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "message", relativeTo: base)!
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
            .post()
            .url(url)
            .contentType(type: .json)
            .body(add: "to", value: to)
            .body(add: "subject", value: subject)
            .body(add: "text", value: text)
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
    
    func requestReply(text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "message/\(id)/reply", relativeTo: base)!
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
            .post()
            .url(url)
            .contentType(type: .json)
            .body(add: "text", value: text)
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
    
    func requestDelete(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "message/\(id)", relativeTo: base)!
        guard let network = self.oauthRequest() else { return completion(nil) }
        network
            .delete()
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
