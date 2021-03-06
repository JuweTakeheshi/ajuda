//
//  JUWNetworkManager.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit
import Alamofire

class JUWNetworkManager: NSObject {

    func post(url: String, parameters: [String: String], completion: @escaping (_ result: Any?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request(url, method: .post, parameters: parameters,encoding:JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(response.result.value)
                case .failure:
                    failure(response.error)
                }
        }
    }
    
    func put(url: String, parameters: [String: String], completion: @escaping (_ result: Any?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request(url, method: .put, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(response.result.value)
                case .failure:
                    failure(response.error)
                }
        }
    }
    
    func patch(url: String, parameters: [String: String], completion: @escaping (_ result: Any?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request(url, method: .patch, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(response.result.value)
                case .failure:
                    failure(response.error)
                }
        }
    }

    func get(url: String, completion: @escaping (_ result: Any?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request(url, method: .get, parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(response.result.value)
                case .failure:
                    failure(response.error)
                }
        }
    }
    
    func delete(url: String, completion: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request(url, method: .delete, parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion()
                case .failure:
                    failure(response.error)
                }
        }
    }
}
