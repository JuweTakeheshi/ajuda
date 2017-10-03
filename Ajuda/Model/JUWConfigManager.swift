//
//  JUWConfigManager.swift
//  Ajuda
//
//  Created by Nelida Velazquez on 9/28/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import Foundation

class JUWConfigManager {
    // MARK: - Singleton configuration
    static let shared = JUWConfigManager()
    private init() {}
    
    var config: JUWConfig!
    
    func loadConfig(completion: @escaping () -> Void) {
        JUWNetworkManager().get(url: kConfigUrl, completion: { result in
            guard let dictionary = result as? [String: Any] else {
                completion()
                return
            }
            self.config = JUWConfig(dictionary: dictionary)
            completion()
        }) { error in
            completion()
        }
    }
}
