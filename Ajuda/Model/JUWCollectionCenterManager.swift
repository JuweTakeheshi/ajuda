//
//  JUWCollectionCenterManager.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit
import RealmSwift

class JUWCollectionCenterManager: NSObject {
    func getCollectionCenters(centers: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let networkManager = JUWNetworkManager()
        networkManager.get(url: kCollectionCentersUrl, completion: { (result) in
            DispatchQueue.global().async {
                if let array = result as? [Any] {
                    let realm = try! Realm()

                    for value in array {
                        if let dictionary = value as? [String: Any] {
                            let predicate = NSPredicate(format: "centerIdentifier = %i", dictionary["id"] as! Int)
                            var center = realm.objects(JUWCollectionCenter.self).filter(predicate).first
                            if center == nil {
                                center = JUWCollectionCenter()
                                try! realm.write {
                                    realm.add(center!)
                                }
                            }

                            try! realm.write {
                                center?.name = dictionary["nombre"] as! String
                                center?.address = dictionary["direccion"] as! String
                                center?.latitude = dictionary["latitud"] as! Double
                                center?.longitude = dictionary["longitud"] as! Double
                                center?.centerIdentifier = dictionary["id"] as! Int32

                                if let peopleInChargeArray = dictionary["responsables"] as? [Any] {
                                    if peopleInChargeArray.count > 0 {
                                        if let peopleInCharge = peopleInChargeArray[0] as? [String: Any] {
                                            center?.phoneNumber = peopleInCharge["telefono"] as! String
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        centers()
                    }
                }
            }
        }) { (error) in
            failure(error!)
        }
    }
}
