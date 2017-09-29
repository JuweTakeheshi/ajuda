//
//  JUWConfigManager.swift
//  Ajuda
//
//  Created by Nelida Velazquez on 9/28/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import Foundation

class JUWConfigManager {
    
    func loadConfig(completion: @escaping (_ config: JUWConfig) -> Void) {
        JUWNetworkManager().get(url: kConfigUrl, completion: { result in
            guard let dictionary = result as? [String: Any],
                  let endopoint = dictionary["endpoint"] as? String  else {
                DispatchQueue.main.async { completion(JUWConfig(endpoint: kDefaultEndpoint)) }
                return
            }
            DispatchQueue.main.async { completion(JUWConfig(endpoint: endopoint)) }
            
        }) { error in
            DispatchQueue.main.async { completion(JUWConfig(endpoint: kDefaultEndpoint)) }
        }
    }
}
