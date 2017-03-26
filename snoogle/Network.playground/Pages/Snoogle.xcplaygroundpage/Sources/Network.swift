//
//  Network.swift
//  snoogle
//
//  Created by Vincent Moore on 3/18/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

//[ 'Host',
//  '192.168.1.249:3000',
//  'Connection',
//  'keep-alive',
//  'Accept',
//  '*/*',
//  'User-Agent',
//  'Snoogle/1 CFNetwork/808.2.16 Darwin/16.5.0',
//  'Accept-Language',
//  'en-us',
//  'Content-Length',
//  '37',
//  'Accept-Encoding',
//  'gzip, deflate' ],

import Foundation

class Network {
    
    private let FIELD_CONTENT_TYPE = "Content-Type"
    private let ERROR_DOMAIN = "NetworkError"
    
    enum NetworkMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum NetworkContentType: String {
        case json = "application/json"
        case form = "application/x-www/form-urlencoded"
    }
    
    enum NetworkParseType: Int {
        case json = 0
        case text = 1
        case none = 2
    }
    
    enum NetworkError: Int {
        case parsing = 0
        case casting = 1
    }
    
    enum StatusCode: Int {
        case success = 0
        case failure = 1
    }
    
    private lazy var urlRequest: URLRequest = {
        return self.buildRequest()
    }()
    
    private var components: URLComponents! = URLComponents()
    private var parseType: NetworkParseType = .none
    private var body = [String:Any]()
    
    private var successCompletion: ((Any?, HTTPURLResponse)->Void)?
    private var failureCompletion: ((Any?, HTTPURLResponse)->Void)?
    private var errorCompletion:((Error)->Void)?
    
    
    private var contentType: NetworkContentType {
        if let contentType = urlRequest.value(forHTTPHeaderField: FIELD_CONTENT_TYPE), let type = NetworkContentType(rawValue: contentType) {
            return type
        }
        return .form
    }
    
    private func buildRequest() -> URLRequest {
        var req = NSMutableURLRequest() as URLRequest
        req.allowsCellularAccess = true
        return req
    }
    
    private func buildComponents() -> URLComponents {
        var comp = URLComponents()
        comp.query = ""
        return comp
    }
    
    func request() -> Network {
        urlRequest = buildRequest()
        components = URLComponents()
        return self
    }
    
    func url(_ url: URL) -> Network {
        components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        return self
    }
    
    private func method(type: NetworkMethod) -> Network {
        urlRequest.httpMethod = type.rawValue
        return self
    }
    
    func get() -> Network {
        return method(type: .get)
    }
    
    func put() -> Network {
        return method(type: .put)
    }
    
    func post() -> Network {
        return method(type: .post)
    }
    
    func delete() -> Network {
        return method(type: .delete)
    }
    
    func success(completion: ((Any?, HTTPURLResponse)->Void)?) -> Network {
        self.successCompletion = completion
        return self
    }
    
    func failure(completion: ((Any?, HTTPURLResponse)->Void)?) -> Network {
        self.failureCompletion = completion
        return self
    }
    
    func error(completion: ((Error)->Void)?) -> Network {
        self.errorCompletion = completion
        return self
    }
    
    func contentType(type: NetworkContentType) -> Network {
        return header(set: FIELD_CONTENT_TYPE, value: type.rawValue)
    }
    
    func header(add key: String, value: String) -> Network {
        urlRequest.addValue(value, forHTTPHeaderField: key)
        return self
    }
    
    func header(set key: String, value: String) -> Network {
        urlRequest.setValue(value, forHTTPHeaderField: key)
        return self
    }
    
    func query(key: String, item: String) -> Network {
        if components.query == nil { components.query = "" }
        let item = URLQueryItem(name: key, value: item)
        components.queryItems?.append(item)
        return self
    }
    
    func query(key: String, items: [String]) -> Network {
        if components.query == nil { components.query = "" }
        let queryItems = items.map { (item: String) -> URLQueryItem in
            return URLQueryItem(name: key, value: item)
        }
        components.queryItems?.append(contentsOf: queryItems)
        return self
    }
    
    func parse(type: NetworkParseType) -> Network {
        parseType = type
        return self
    }
    
    func body(add key: String, value: Any) -> Network {
        body[key] = value
        
        // default content type
        if let _ = urlRequest.value(forHTTPHeaderField: FIELD_CONTENT_TYPE) {
            return self
        } else {
            return contentType(type: .form)
        }
    }
    
    func body(set body: [String:Any]) -> Network {
        self.body = body
        
        // default content type
        if let _ = urlRequest.value(forHTTPHeaderField: FIELD_CONTENT_TYPE) {
            return self
        } else {
            return contentType(type: .form)
        }
    }
    
    private func sendRequest(completion: @escaping ((Any?, URLResponse?, Error?)->Void)) {
        urlRequest.url = components.url
        print(urlRequest.url?.absoluteString)
        if !body.isEmpty {
            switch contentType {
            case .form:
                
                var error: Error? = nil
                // Solution http://stackoverflow.com/questions/28008874/post-with-swift-and-api
                let parameterArray = body.map { (key, value) -> String in
                    let stringValue = String(describing: value)
                    let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._* ")
                    let encoded = stringValue.addingPercentEncoding(withAllowedCharacters: allowed)?.replacingOccurrences(of: " ", with: "+")
                    if let encoded = encoded {
                        return "\(key)=\(encoded)"
                    }
                    error = NSError(
                        domain: ERROR_DOMAIN,
                        code: NetworkError.parsing.rawValue,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Error parsing form data.",
                            NSLocalizedFailureReasonErrorKey: "Could not encode dictionary.",
                            NSLocalizedRecoverySuggestionErrorKey: "Make sure to supply [String: String] for form data."])
                    return ""
                }
                
                if let error = error { return completion(nil,nil,error) }
                urlRequest.httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
                
            case .json:
                do {
                    let json = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                    urlRequest.httpBody = json
                } catch let error {
                    return completion(nil,nil,error)
                }
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest){ (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data, let response = response else {
                return completion(nil, nil, error)
            }
            
            switch self.parseType {
            case .json:
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    return completion(json, response, error)
                } catch let jsonError {
                    return completion(nil, response, jsonError)
                }
            case .text:
                let text = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                return completion(text, response, error)
            case .none:
                return completion(data, response, error)
            }
        }.resume()
    }
    
    func sendHTTP() {
        
        sendRequest { [weak self] (data: Any?, response: URLResponse?, error: Error?) in
            if let this = self {
                if let error = error, let errorCompletion = this.errorCompletion { return errorCompletion(error) }
                
                guard let response = response as? HTTPURLResponse else {
                    if let errorCompletion = self?.errorCompletion {
                        let castError = NSError(
                            domain: this.ERROR_DOMAIN,
                            code: NetworkError.casting.rawValue,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Error casting URLResponse -> HTTPURLResponse.",
                                NSLocalizedFailureReasonErrorKey: "Response is not an instance of HTTPURLResponse.",
                                NSLocalizedRecoverySuggestionErrorKey: "Make sure this is a HTTP(S) request."])
                        return errorCompletion(castError)
                    }
                    return
                }
                
                if response.statusCode < 200 && response.statusCode > 299, let failureCompletion = this.failureCompletion {
                    return failureCompletion(data, response)
                }
                
                if let successCompletion = this.successCompletion {
                    return successCompletion(data, response)
                }
            }
        }
    }
    
    func send() {
        
        sendRequest { [weak self] (data: Any?, response: URLResponse?, error: Error?) in
            if let this = self {
                if let error = error, let errorCompletion = this.errorCompletion {
                    return errorCompletion(error)
                }
                
                if let successCompletion = this.successCompletion, let response = response as? HTTPURLResponse {
                    return successCompletion(data, response)
                }
            }
        }
        
    }
    
}
