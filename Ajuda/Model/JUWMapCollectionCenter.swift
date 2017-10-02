//
//  JUWMapCollectionCenter.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/22/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

//TODO: GET RID OF THIS CLASS. THIS PROXY OBJECT SUCKS BUT I HAVEN'T SLEPT IN 20 HRS AND I DON'T KNOW HOW TO AVOID IT

import UIKit
import MapKit
import RealmSwift

class JUWMapCollectionCenter: NSObject, MKAnnotation {
    let title: String?
    let name: String
    let address: String
    let phoneNumber: String
    let centerIdentifier: String
    let twitterHandle: String
    let coordinate: CLLocationCoordinate2D
    let keychain = KeychainSwift()

    init(title: String,
         name: String,
         address: String,
         phoneNumber: String,
         identifier: String,
         twitter: String,
         coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.name = name
        self.address = address
        self.twitterHandle = twitter
        self.phoneNumber = phoneNumber
        self.centerIdentifier = identifier
        self.coordinate = coordinate
        super.init()
    }

    var subtitle: String? {
        return address
    }

    func retrieveContacInfotWith(completion: @escaping (_ resultPhone: String) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let networkManager = JUWNetworkManager()
        let url = JUWConfigManager.shared.config.infoURL(for: centerIdentifier)
        networkManager.get(url: url, completion: { (result) in
            DispatchQueue.global().async {
                if let array = result as? [Any] {
                    let realm = try! Realm()
                    let storedProducts = realm.objects(JUWProduct.self)
                    for localProduct in storedProducts {
                        let predicate = NSPredicate(format: "id == %@", localProduct.identifier)
                        let foundItems = array.filter{ predicate.evaluate(with: $0) }
                        if foundItems.count == 0 {
                            #if DEBUG
                                print("product not anymore in server", localProduct.identifier)
                            #endif
                            try! realm.write {
                                realm.delete(localProduct)
                            }
                        }
                    }

                    let predicate = NSPredicate(format: "centerIdentifier = %@", self.centerIdentifier)
                    let center = realm.objects(JUWCollectionCenter.self).filter(predicate).first

                    for contactValue in array {
                        if let dictionary = contactValue as? [String: Any] {
                            DispatchQueue.main.async {
                                if let phoneNumber = dictionary["telefono"] as? String {
                                    completion(phoneNumber)
                                }
                            }

                            try! realm.write {
                                if let phoneNumber = dictionary["telefono"] as? String {
                                    center?.phoneNumber = phoneNumber
                                }

                                if let name = dictionary["nombre"] as? String {
                                    center?.contactName = name
                                }

                                if let eMail = dictionary["email"] as? String {
                                    center?.contactEmail = eMail
                                }

                                if let twitter = dictionary["twitter"] as? String {
                                    center?.twitterHandle = twitter
                                }

                                if let facebook = dictionary["twitter"] as? String {
                                    center?.facebookHandle = facebook
                                }
                            }
                        }
                    }
                }
            }
        }) { (error) in
          print("Error")
            failure(error!)
        }
    }

    func retrieveProductsWith(completion: @escaping (_ result: [Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let networkManager = JUWNetworkManager()
        let url = JUWConfigManager.shared.config.productsURL(for: centerIdentifier)
        networkManager.get(url: url, completion: { (result) in
            DispatchQueue.global().async {
                if let productsArray = result as? [Any] {
                    let realm = try! Realm()
                    var products = [JUWProduct]()
                    let predicate = NSPredicate(format: "centerIdentifier = %@", self.centerIdentifier)
                    let collectionCenter = realm.objects(JUWCollectionCenter.self).filter(predicate).first!
                    for productObject in productsArray {
                        if let productDictionary = productObject as? [String: Any] {
                            let product = JUWProduct()
                            try! realm.write {
                                if let name = productDictionary["nombre"] as? String {
                                    product.name = name
                                }

                                if let date = productDictionary["fechaDeActualizacion"] as? String {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                    product.updateDate = formatter.date(from: date)
                                }

                                if let identifier = productDictionary["id"] as? String {
                                    product.identifier = identifier
                                }

                                product.collectionCenter = collectionCenter
                            }

                            products.append(product)
                        }
                    }
                    let productsList = List<JUWProduct>()
                    productsList.append(objectsIn: products)

                    try! realm.write {
                        collectionCenter.products.append(objectsIn: products)
                    }

                    DispatchQueue.main.async {
                        completion(products)
                    }
                }
            }
        }) { (error) in
           failure(error!)
        }
    }
}
