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

    private let networkManager = JUWNetworkManager()
    
    func getCollectionCenters(centers: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
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
                            try! realm.write {
                                if let name = dictionary["nombre"] as? String {
                                    center?.name = name
                                }

                                if let address = dictionary["direccion"] as? String {
                                    center?.address = address
                                }
                                
                                if let identifier = dictionary["id"] as? String {
                                    center?.centerIdentifier = identifier
                                }

                                if let geoPosDictionary = dictionary["geopos"] as? [String: Any] {
                                    if geoPosDictionary.count > 0 {
                                        if let latitude = geoPosDictionary["lat"] as? Double {
                                            center?.latitude = latitude
                                        }
                                        if let longitude = geoPosDictionary["lng"] as? Double {
                                            center?.longitude = longitude
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
    
    func collectionCenters(whichNeed product: String, completion: @escaping (_ result: [JUWCollectionCenter]) -> Void) {
        let query = product.lowercased().stripCharacters(in: CharacterSet.alphanumerics.inverted)
        precondition(!query.isEmpty, "Query should not be an empty")
        
        var collectionCenter: [JUWCollectionCenter] = []
    
        networkManager.get(url: "https://hapi.balterbyte.com/api/productos?filter=%7B%22where%22:%7B%22nombre%22:%7B%22like%22:%22\(query)%22%7D%7D%7D", completion: { (result) in
            
            if let array = result as? [Any] {
                let realm = try! Realm()
                
                for value in array {
                    if let dictionary = value as? [String: Any] {
                        
                        let predicate = NSPredicate(format: "centerIdentifier = %@", dictionary["acopioId"] as! String)
                        if let center = realm.objects(JUWCollectionCenter.self).filter(predicate).first {
                            collectionCenter.append(center)
                        }
                    }
                }
            }
            completion(collectionCenter)
        }) { (error) in
            completion(collectionCenter)
        }
    }
}

extension String {
    func stripCharacters(in set: CharacterSet) -> String {
        return self.components(separatedBy: set).joined(separator: "")
    }
}
