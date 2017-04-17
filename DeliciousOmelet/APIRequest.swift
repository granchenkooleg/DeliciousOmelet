//
//  APIRequest.swift
//  DeliciousOmelet
//
//  Created by Oleg on 3/25/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func requestHandler(_ function: Any, urlRequest: URLRequestConvertible, completionHandler: @escaping (JSON?) -> Void) {
    
    Alamofire.request(urlRequest)
        .validate()
        .responseJSON { response in
            var errorDescription = ""
            var errorReason = ""
            if case let .failure(error) = response.result {
                if let error = error as? AFError {
                    switch error {
                    case .invalidURL(let url):
                        errorReason = "Invalid URL: " + "\(url) - \(error.localizedDescription)"
                    case .parameterEncodingFailed(let reason):
                        errorDescription = "Parameter encoding failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    case .multipartEncodingFailed(let reason):
                        errorDescription = "Multipart encoding failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    case .responseValidationFailed(let reason):
                        errorDescription = "Response validation failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                        
                        switch reason {
                        case .dataFileNil, .dataFileReadFailed:
                            errorDescription = "Downloaded file could not be read"
                        case .missingContentType(let acceptableContentTypes):
                            errorDescription = "Content Type Missing: " + "\(acceptableContentTypes)"
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            errorDescription = "Response content type: " + "\(responseContentType) " + "was unacceptable: " + "\(acceptableContentTypes)"
                        case .unacceptableStatusCode(let code):
                            errorDescription = "Response status code was unacceptable: " + "\(code)"
                        }
                    case .responseSerializationFailed(let reason):
                        errorDescription = "Response serialization failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    }
                    
                    errorDescription =  "Underlying error: " + "\(error.underlyingError)"
                } else if let error = error as? URLError {
                    errorDescription = "URLError occurred: " + "\(error)"
                } else {
                    errorDescription = "Unknown error: " + "\(error)"
                }
                completionHandler(nil)
            }
            
            if case let .success(value) = response.result {
                let json = JSON(value)

                completionHandler(json)
            }
    }
}

let encodedRequestHalper: ((HTTPMethod, [String: AnyObject]?, URL) throws -> URLRequest) = { method, parameters, url in
    var _urlRequest = URLRequest(url: url)
    
    _urlRequest.httpMethod = method.rawValue
    return try URLEncoding.default.encode(_urlRequest, with: parameters)
}

enum UserRequest: URLRequestConvertible {
    
    case getRecipePuppy([String: AnyObject])
    case getSearchURL([String: AnyObject])
    
    
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            switch self {
            case  .getRecipePuppy, .getSearchURL:
                return .get
            }
        }
        
        let params: ([String: AnyObject]?) = {
            switch self {
                
            case .getRecipePuppy(let newPost):
                return newPost
            case .getSearchURL(let newPost):
                return newPost
            }
        }()
        
        let url: URL = {
            let relativePath:String?
            switch self {
                
            case .getRecipePuppy:
                relativePath = ""
            case .getSearchURL:
                relativePath = ""
            }
            
            var URL = Foundation.URL(string: Constants.baseURLString)!
            if let relativePath = relativePath {
                URL = URL.appendingPathComponent(relativePath)
            }
            return URL
        }()
        
        return try encodedRequestHalper(method, params, url)
    }
    
    
    
    static func recipePuppy (_ entryParams: [String : AnyObject], completion: @escaping (JSON) -> Void) {
        requestHandler(#function, urlRequest: getRecipePuppy(entryParams), completionHandler: { json in
            guard let json = json else {
                return
            }
            print (">>recipePuppy - \(json)<<")
            completion(json)
        })
    }
    
    
    static func searchURL(_ entryParams: [String : AnyObject], completion: @escaping (JSON) -> Void) {
        requestHandler(#function, urlRequest: getSearchURL(entryParams), completionHandler: { json in
            guard let json = json else {
                return
            }
            print (">>searchURL - \(json)<<")
            completion(json)
        })
    }
    
    
    
    //    static func makelogin(_ entryParams: [String : AnyObject], completion: @escaping (Bool) -> Void) {
    //        requestHandler(#function, urlRequest: login(entryParams)) { json in
    //            guard let json = json, json[0]["error"] == false else {
    //                UIAlertController.alert("Введите корректные данные!".ls).show()
    //                completion(false)
    //                return
    //            }
    //            print (">>self - \(json)<<")
    //            User.setupUser(id: "\(json[0]["data"]["id"])", firstName: "\(json[0]["data"]["username"])", email: "\(json[0]["data"]["email"])", phone: "\(json[0]["data"]["phone"])")
    //            // For InfoAboutUserForOrder Realm table
    //            InfoAboutUserForOrder.setupAllUserInfo(name: "\(json[0]["data"]["username"])", phone: "\(json[0]["data"]["phone"])", city: "Одесса")
    //
    //            completion(true)
    //        }
    //    }
    
    //    static func makeRegistration(_ entryParams: [String : AnyObject], completion: @escaping (Bool) -> Void) {
    //        requestHandler(#function, urlRequest: registration(entryParams)) { json in
    //            guard let json = json, json[0]["error"] == false else {
    //                //UIAlertController.alert("Пользователь с такими данными уже зарегистрирован!".ls).show()
    //                completion(false)
    //                return
    //            }
    //
    //            User.setupUser(id: "\(json[0]["data"]["id"])", firstName: "\(json[0]["data"]["username"])")
    //            completion(true)
    //        }
    //    }
    
}

