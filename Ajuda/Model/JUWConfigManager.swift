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
                  let endpoint = dictionary["endpoint"] as? String,
                  let version = dictionary["version"] as? String  else {
                completion(JUWConfig())
                return
            }
            completion(JUWConfig(endpoint: endpoint, version: version))
        }) { error in
            completion(JUWConfig())
        }
    }
}
