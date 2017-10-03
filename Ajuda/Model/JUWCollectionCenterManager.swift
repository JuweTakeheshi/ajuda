//
//  JUWCollectionCenterManager.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit
import RealmSwift

typealias OnUpdateCompletion = (_ result: Result<[JUWCollectionCenter], Error>) -> ()
typealias OnSearchResults = (_ result: [JUWCollectionCenter]) -> ()
typealias OnProductAdditionCompletion = (_ result: Result< Any, Error>) -> ()

class JUWCollectionCenterManager: NSObject {

    private let networkManager = JUWNetworkManager()
    let keychain = KeychainSwift()
    
    func collectionCentersFromCache() -> [JUWCollectionCenter] {
        let realm = try! Realm()
        return Array(realm.objects(JUWCollectionCenter.self))
    }

    func updateCollectionCenters(completion: @escaping OnUpdateCompletion) {
        networkManager.get(url: JUWConfigManager.shared.config.collectionCentersURL(), completion: { result in
            guard let array = result as? [[String: Any]]  else {
                DispatchQueue.main.async { completion(.failure(nil)) }
                return
            }
            let realm = try! Realm()
            realm.deleteCollectionCenters(notIn: array)
            realm.addCollectionCenters(in: array)
            let collectionCenters = Array(realm.objects(JUWCollectionCenter.self))
            DispatchQueue.main.async { completion(.success(collectionCenters)) }
        }) { (error) in
            DispatchQueue.main.async { completion(.failure(error)) }
        }
    }
    
    func collectionCenters(whichNeed product: String, completion: @escaping OnSearchResults) {
        let query = product.lowercased().stripCharacters(in: CharacterSet.alphanumerics.inverted)
        precondition(!query.isEmpty, "Query should not be empty")
        guard let url = JUWConfigManager.shared.config.searchURL(for: query).encoded() else {
            DispatchQueue.main.async { completion([]) }
            return
        }
        networkManager.get(url: url, completion: { (result) in
            guard let array = result as? [[String: Any]]  else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            let realm = try! Realm()
            let centers = realm.collectionCenters(with: array)
            DispatchQueue.main.async { completion(centers) }
        }) { (error) in
            DispatchQueue.main.async { completion([]) }
        }
    }

    func addProduct(to collectionCenter: JUWCollectionCenter,
                                      product: String,
                                      completion: @escaping OnProductAdditionCompletion) {
        let url = JUWConfigManager.shared.config.addProductURL(to: collectionCenter.centerIdentifier)
        networkManager.post(url: url, parameters:["nombre":product], completion: { _ in
            DispatchQueue.main.async { completion(.success(nil)) }
        }, failure: { error in
            DispatchQueue.main.async { completion(.failure(error)) }
        })
    }
}

extension Realm {
    
    func deleteCollectionCenters(notIn array: [[String: Any]]) {
        let storedCenters = self.objects(JUWCollectionCenter.self)
        for localCenter in storedCenters {
            let predicate = NSPredicate(format: "id == %@", localCenter.centerIdentifier)
            let foundItems = array.filter{ predicate.evaluate(with: $0) }
            if foundItems.count == 0 {
                #if DEBUG
                    print("center not anymore in server", localCenter.centerIdentifier)
                #endif
                try! self.write {
                    self.delete(localCenter)
                }
            }
        }
    }
    
    func addCollectionCenters(in array: [[String: Any]]) {
        for dictionary in array {
            let predicate = NSPredicate(format: "centerIdentifier = %@", dictionary["id"] as! String)
            var center = self.objects(JUWCollectionCenter.self).filter(predicate).first
            if center == nil {
                center = JUWCollectionCenter()
                try! self.write {
                    self.add(center!)
                }
            }
            try! self.write {
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
    
    func collectionCenters(with results: [[String: Any]]) -> [JUWCollectionCenter] {
        var collectionCenters: [JUWCollectionCenter] = []
        let ids = results.flatMap { dictionary in
            return dictionary["acopioId"] as? String
        }
        for id in ids {
            let predicate = NSPredicate(format: "centerIdentifier = %@", id)
            if let center = self.objects(JUWCollectionCenter.self).filter(predicate).first {
                collectionCenters.append(center)
            }
        }
        return collectionCenters
    }
}
