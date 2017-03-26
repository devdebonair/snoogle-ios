import Foundation
import RealmSwift

class ServiceUser: Service {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func fetch(completion: ((Bool)->Void)? = nil) {
        requestFetch { (json: [String : Any]?) in
            if let json = json, let user = User(JSON: json) {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(user, update: true)
                    }
                    if let completion = completion { return completion(true) }
                } catch {
                    if let completion = completion { return completion(false) }
                }
            }
        }
    }
    
    func submissions(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        requestSubmissions { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func comments(sort: ListingSort = .hot, completion: ((Bool)->Void)? = nil) {
        requestComments { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func add(completion: ((Bool)->Void)? = nil) {
        requestAdd { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func remove(completion: ((Bool)->Void)? = nil) {
        requestRemove { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
    
    func trophies(completion: ((Bool)->Void)? = nil) {
        requestTrophies { (json: [String : Any]?) in
            if let _ = json {
                if let completion = completion { return completion(true) }
            } else {
                if let completion = completion { return completion(false) }
            }
        }
    }
}

// Network
extension ServiceUser {
    func requestFetch(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "users/\(name)", relativeTo: base)!
        Network()
            .get()
            .url(url)
            .parse(type: .json)
            .success { (data: Any?, response: HTTPURLResponse) in
                if let json = data as? [String:Any], let user = User(JSON: json) {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(user, update: true)
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
            .sendHTTP()
    }
    
    func requestSubmissions(sort: ListingSort = .hot, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "users/\(name)/submissions/\(sort.rawValue)", relativeTo: base)!
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
    
    func requestComments(sort: ListingSort = .hot, completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "users/\(name)/comments/\(sort)", relativeTo: base)!
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
    
    func requestAdd(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "users/\(name)/friend", relativeTo: base)!
        Network()
            .post()
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
    
    func requestRemove(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "users/\(name)/unfriend", relativeTo: base)!
        Network()
            .post()
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
    
    func requestTrophies(completion: @escaping ([String:Any]?)->Void) {
        let url = URL(string: "users/\(name)/trophies", relativeTo: base)!
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
}
