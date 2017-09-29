//
//  JUWUrl.swift
//  Ajuda
//
//  Created by Nelida Velazquez on 9/28/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

class JUWUrl {
    static let shared = JUWUrl()
    private var optionalConfig: JUWConfig?
    
    private init() {}

    func setup(with config: JUWConfig) {
        self.optionalConfig = config
    }
    
    private var config: JUWConfig {
        guard let unwrappedConfig = optionalConfig else {
            fatalError("JUWUrl needs to be set up with a config object before it can be used")
        }
        return unwrappedConfig
    }
    
    // MARK: - Available URLs
    
    func userAuthentication() -> String {
        return "\(config.endpoint)/api/voluntarios/login"
    }
    
    func userCreation() -> String {
        return "\(config.endpoint)/api/voluntarios"
    }
    
    func collectionCenters() -> String {
        guard let token = KeychainSwift().get(kTokenKey), config.version != kDefaultVersion  else {
            return "\(config.endpoint)/api/acopios"
        }
        return "\(config.endpoint)/api/acopios?access_token=\(token)"
    }
    
    func productsNeeded(`for` collectionCenter: String) -> String {
        guard let token = KeychainSwift().get(kTokenKey),config.version != kDefaultVersion  else {
            return "\(config.endpoint)/api/acopios/\(collectionCenter)/productos"
        }
        return "\(config.endpoint)/api/acopios/\(collectionCenter)/acceptan?access_token=\(token)"
    }
    
    func info(`for` collectionCenter: String ) -> String {
        guard let token = KeychainSwift().get(kTokenKey), config.version != kDefaultVersion  else {
            return "\(config.endpoint)/api/acopios/\(collectionCenter)/contactos"
        }
        return "\(config.endpoint)/api/acopios/\(collectionCenter)/contactos?access_token=\(token)"
    }
    
    func collectionCenters(whichNeed product: String) -> String {
        guard let token = KeychainSwift().get(kTokenKey), config.version != kDefaultVersion  else {
            return "\(config.endpoint)/api/productos?filter={\"where\":{\"nombre\":{\"like\":\"\(product)\"}}}"
        }
        return "\(config.endpoint)/api/acceptan?filter={\"where\":{\"nombre\":{\"like\":\"\(product)\"}}}?access_token=\(token)"
    }
    
    func addProduct(to collectionCenter: String) -> String {
        guard let token = KeychainSwift().get(kTokenKey), config.version != kDefaultVersion  else {
            return "\(config.endpoint)/api/acopios/\(collectionCenter)/aceptan"
        }
        return "\(config.endpoint)/api/acopios/\(collectionCenter)/aceptan?access_token=\(token)"
    }
}
