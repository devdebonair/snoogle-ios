import Foundation
import RealmSwift

class ServiceComment: Service {
    
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    func fetch(completion: ((Bool)->Void)? = nil) {
        requestFetch { (json: [String : Any]?) in
            if let json = json, let comment = Comment(JSON: json) {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(comment, update: true)
                    }
                    if let completion = completion { return completion(true) }
                } catch {
                    if let completion = completion { return completion(false) }
                }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func upvote(completion: ((Bool)->Void)? = nil) {
        requestUpvote { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func downvote(completion: ((Bool)->Void)? = nil) {
        requestDownvote { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func save(completion: ((Bool)->Void)? = nil) {
        requestSave { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func unvote(completion: ((Bool)->Void)? = nil) {
        requestUnvote { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func unsave(completion: ((Bool)->Void)? = nil) {
        requestUnsave { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    // check why contenttype needs to be specified.
    func reply(text: String, completion: ((Bool)->Void)? = nil) {
        requestReply(text: text) { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    // check why contenttype needs to be specified.
    func edit(text: String, completion: ((Bool)->Void)? = nil) {
        requestEdit(text: text) { (json: [String : Any]?) in
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

extension ServiceComment {
    func requestFetch(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "comments/\(id)", relativeTo: base)!
        Network()
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
    
    func requestUpvote(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "comments/\(id)/upvote", relativeTo: base)!
        Network()
            .post()
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
    
    func requestDownvote(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "comments/\(id)/downvote", relativeTo: base)!
        Network()
            .post()
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
    
    func requestSave(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "comments/\(id)/save", relativeTo: base)!
        Network()
            .post()
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
    
    func requestUnvote(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "comments/\(id)/unvote", relativeTo: base)!
        Network()
            .post()
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
    
    func requestUnsave(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "comments/\(id)/unsave", relativeTo: base)!
        Network()
            .post()
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
    
    // check why contenttype needs to be specified.
    func requestReply(text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "comments/\(id)/reply", relativeTo: base)!
        Network()
            .post()
            .url(url)
            .contentType(type: .json)
            .body(add: "text", value: text)
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
    
    // check why contenttype needs to be specified.
    func requestEdit(text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "comments/\(id)", relativeTo: base)!
        Network()
            .put()
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
        let url = URL(string: "comments/\(id)", relativeTo: base)!
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
}
