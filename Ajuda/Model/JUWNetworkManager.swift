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

    func post(parameters: [String: String], completion: @escaping (_ result: String?) -> Void) {
        Alamofire.request("http://backend.com").responseJSON { response in
            completion("OK")
        }
    }
}
