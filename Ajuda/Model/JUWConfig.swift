//
//  JUWConfig.swift
//  Ajuda
//
//  Created by Nelida Velazquez on 9/28/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

class JUWConfig {
    private var items: [String: Any]
    
    init(dictionary: [String: Any]) {
        guard let array = dictionary["items"] as? [[String: Any]], let raw = array.first else {
            fatalError("Needs config information to be initialized")
        }
        self.items = raw
    }
    
    private var isAuthRequired: Bool {
        guard let auth = items["authentication-required"] as? Bool else {
            return false
        }
        return auth
    }

    // MARK: - Available URLs
    
    func userLoginURL() -> String {
        guard let loginURL = items["sign-in"] as? String else {
            return "\(kDefaultEndpoint)/api/voluntarios/login"
        }
        return loginURL
    }
    
    func userSingUpURL() -> String {
        guard let singUpURL = items["sign-up"] as? String else {
            return "\(kDefaultEndpoint)/api/voluntarios"
        }
        return singUpURL
    }
    
    func collectionCentersURL() -> String {
        guard let centersURL = items["acopios"] as? String else {
            return "\(kDefaultEndpoint)/api/acopios"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey)  {
            return "\(centersURL)?access_token=\(token)"
        }
        return centersURL
    }
    
    func productsURL(`for` collectionCenter: String) -> String {
        guard let productsURL = items["acopios-aceptan"] as? String else {
            return "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/productos"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey) {
            return "\(productsURL)?access_token=\(token)"
        }
        return productsURL
    }
    
    func infoURL(`for` collectionCenter: String ) -> String {
        guard let infoURL = items["acopios-contactos"] as? String else {
            return "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/contactos"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey) {
            return "\(infoURL)?access_token=\(token)"
        }
        return infoURL
    }
    
    func searhURL(`for` product: String) -> String {
        guard let searchURL = items["acopios-search"] as? String else {
            return "\(kDefaultEndpoint)/api/productos?filter={\"where\":{\"nombre\":{\"like\":\"\(product)\"}}}"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey) {
            return "\(searchURL)?access_token=\(token)"
        }
        return searchURL
    }
    
    func addProductURL(to collectionCenter: String) -> String {
        guard let addProductURL = items["acopios-add-product"] as? String else {
            return "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/aceptan"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey) {
            return "\(addProductURL)?access_token=\(token)"
        }
        return addProductURL
    }
}
