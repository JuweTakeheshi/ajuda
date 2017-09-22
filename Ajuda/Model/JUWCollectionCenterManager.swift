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
                            let predicate = NSPredicate(format: "centerIdentifier = %@", dictionary["id"] as! String)
                            var center = realm.objects(JUWCollectionCenter.self).filter(predicate).first
                            if center == nil {
                                center = JUWCollectionCenter()
                                try! realm.write {
                                    realm.add(center!)
                                }
                            }

                            //http://acopio-api.skycatch.net/v1/acopios
//                            try! realm.write {
//                                center?.name = dictionary["nombre"] as! String
//                                center?.address = dictionary["direccion"] as! String
//                                // API is broken
//                                center?.latitude = dictionary["latitud"] as! Double
//                                center?.longitude = dictionary["longitud"] as! Double
//                                center?.centerIdentifier = dictionary["id"] as! Int32
//
//                                if let peopleInChargeArray = dictionary["responsables"] as? [Any] {
//                                    if peopleInChargeArray.count > 0 {
//                                        if let peopleInCharge = peopleInChargeArray[0] as? [String: Any] {
//                                            center?.phoneNumber = peopleInCharge["telefono"] as! String
//                                        }
//                                    }
//                                }
//                            }
                            //http://ec2-54-242-119-209.compute-1.amazonaws.com/api/acopios
                            /*{
                             "legacy_id": "29",
                             "nombre": "365",
                             "direccion": "Calle Bajío 365. Condesa. Cuauhtémoc. Ciudad de México",
                             "geopos": {
                             "lat": 19.402515,
                             "lng": -99.170374
                             },
                             "id": "59c4c10500220a53359e04d9"
                             },*/
                            try! realm.write {
                                center?.name = dictionary["nombre"] as! String
                                center?.address = dictionary["direccion"] as! String
                                // API is broken
//                                center?.latitude = dictionary["latitud"] as! Double
//                                center?.longitude = dictionary["longitud"] as! Double
                                center?.centerIdentifier = dictionary["id"] as! String
                                
                                if let geoPosDictionary = dictionary["geopos"] as? [String: Any] {
                                    if geoPosDictionary.count > 0 {
                                        center?.latitude = geoPosDictionary["lat"] as! Double
                                        center?.longitude = geoPosDictionary["lng"] as! Double
//                                        for value in geoPosArray {}
//                                        if let peopleInCharge = geoPosArray[0] as? [String: Any] {
//                                            center?.phoneNumber = peopleInCharge["telefono"] as! String
//                                        }
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
