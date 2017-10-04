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
    
    var isAuthRequired: Bool {
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
            return String(format: "\(centersURL)", "?access_token=\(token)")
        } else {
            return String(format:"%@%@", "\(kDefaultEndpoint)/api/acopios", "")
        }
    }

    func productsURL(`for` collectionCenter: String) -> String {
        guard let productsURL = items["acopios-aceptan"] as? String else {
            return "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/productos"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey) {
            return String(format: "\(productsURL)", "\(collectionCenter)", "?access_token=\(token)")
        } else {
            return String(format: "%@%@", "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/productos", "")
        }
    }

    func infoURL(`for` collectionCenter: String ) -> String {
        guard let infoURL = items["acopios-contactos"] as? String else {
            return "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/contactos"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey) {
            return String(format: "\(infoURL)", "\(collectionCenter)", "?access_token=\(token)")
        }
        else {
            return String(format: "%@%@", "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/contactos", "")
        }
    }

    func searchURL(`for` product: String) -> String {
        guard let searchURL = items["acopios-search"] as? String else {
            return "\(kDefaultEndpoint)/api/productos?filter={\"where\":{\"nombre\":{\"like\":\"\(product)\"}}}"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey) {
            return String(format: "\(searchURL)", "{\"where\":{\"nombre\":{\"like\":\"\(product)\"}}}", "&access_token=\(token)")
        }
        else {
            return String(format: "%@%@", "\(kDefaultEndpoint)/api/productos?filter={\"where\":{\"nombre\":{\"like\":\"\(product)\"}}}", "")
        }
    }

    func addProductURL(to collectionCenter: String) -> String {
        guard let addProductURL = items["acopios-aceptan"] as? String else {
            return "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/aceptan"
        }
        if isAuthRequired, let token = KeychainSwift().get(kTokenKey) {
            return String(format: "\(addProductURL)", "\(collectionCenter)", "?access_token=\(token)")
        }
        else {
            return String(format: "%@%@", "\(kDefaultEndpoint)/api/acopios/\(collectionCenter)/productos", "")
        }
    }
}
