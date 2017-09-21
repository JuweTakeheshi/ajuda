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

    func post(parameters: [String: AnyObject], completion: @escaping (_ result: String?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request("http://backend.com", method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion("OK")
                case .failure:
                    failure(response.error)
                }
        }
    }
}
