//
//  ServiceMultireddit.swift
//  snoogle
//
//  Created by Vincent Moore on 3/27/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation

class ServiceMultireddit: Service {
    
    var name: String
    
    override init() {
        self.name = ""
    }
    
    init(name: String, completion: ((Bool)->Void)? = nil) {
        self.name = name
    }
    
    func add(subreddit: String, completion: ((Bool)->Void)? = nil) {
        requestAdd(subreddit: subreddit) { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func remove(subreddit: String, completion: ((Bool)->Void)? = nil) {
        requestRemove(subreddit: subreddit) { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func copy(source: String, from username: String, completion: ((Bool)->Void)? = nil) {
        requestCopy(source: source, from: username) { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func edit(changes: MultiredditEdits, completion: ((Bool)->Void)? = nil) {
        requestEdit(changes: changes) { (json: [String : Any]?) in
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
    
    func create(description: String, subreddits: [String], completion: ((Bool)->Void)? = nil) {
        // implement
    }
}

extension ServiceMultireddit {
    func requestAdd(subreddit: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "multireddits/\(name)/subreddits", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .contentType(type: .json)
            .body(add: "subreddit", value: subreddit)
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
    
    func requestRemove(subreddit: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "multireddits/\(name)/subreddits", relativeTo: base)!
        Network()
            .delete()
            .url(url)
            .contentType(type: .json)
            .body(add: "subreddit", value: subreddit)
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
    
    func requestCopy(source: String, from username: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "multireddits/copy", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .contentType(type: .json)
            .body(add: "user", value: username)
            .body(add: "user_multiname", value: source)
            .body(add: "new_multiname", value: name)
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
    
    func requestEdit(changes: MultiredditEdits, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "multireddits/\(name)", relativeTo: base)!
        let network = Network().put().url(url).contentType(type: .json).parse(type: .json)
        if let title = changes.title {
            _ = network.body(add: "title", value: title)
        }
        if let description = changes.description {
            _ = network.body(add: "description", value: description)
        }
        if let icon = changes.icon {
            _ = network.body(add: "icon", value: icon)
        }
        if let color = changes.color {
            _ = network.body(add: "color", value: color)
        }
        if let name = changes.name {
            _ = network.body(add: "name", value: name)
        }
        if let visibility = changes.visibility {
            _ = network.body(add: "visibility", value: visibility)
        }
        if let weight = changes.weight {
            _ = network.body(add: "weight", value: weight)
        }
        
        network
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
        let url = URL(string: "multireddits/\(name)", relativeTo: base)!
        Network()
            .delete()
            .url(url)
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
    
    func requestCreate(description: String, subreddits: [String], completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "multireddits", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .contentType(type: .json)
            .body(add: "name", value: name)
            .body(add: "description", value: description)
            .body(add: "subreddits", value: subreddits)
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
