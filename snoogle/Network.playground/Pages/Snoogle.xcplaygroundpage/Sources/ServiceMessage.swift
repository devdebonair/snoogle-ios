import Foundation
import RealmSwift

class ServiceMessage: Service {
    let id: String
    
    override init() {
        self.id = ""
    }
    
    init(id: String, completion: ((Bool)->Void)? = nil) {
        self.id = id
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
    
    func requestCompose(to: String, subject: String, text: String, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "message", relativeTo: base)!
        Network()
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
        Network()
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
        Network()
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
