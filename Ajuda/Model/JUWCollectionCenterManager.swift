//
//  JUWCollectionCenterManager.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class JUWCollectionCenterManager: NSObject {
    func getCollectionCenters(centers: @escaping (_ result: Any) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let networkManager = JUWNetworkManager()
        networkManager.get(url: kCollectionCentersUrl, completion: { (result) in
            
            centers(result!)
        }) { (error) in
            failure(error!)
        }
    }
}
