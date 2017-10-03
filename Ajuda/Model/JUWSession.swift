//
//  JUWSession.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit

class JUWSession: NSObject {
    static let sharedInstance = JUWSession()
    let userTypes = [UserType.courier, UserType.shelter, UserType.collectionCenter]

    enum UserType: String {
        case courier = "Llevo ayuda"
        case shelter = "Refugio"
        case collectionCenter = "Centro de acopio"
    }

    func isValid() -> Bool {
        return true
    }

    func signInWithUserName(username: String, password: String, completion: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        let networkManager = JUWNetworkManager()
        let parameters = ["email": username, "username": username, "password": password]
        networkManager.post(url: JUWConfigManager.shared.config.userLoginURL(), parameters: parameters, completion: { (result) in
            DispatchQueue.global().async {
                if let dictionary = result as? [String: Any] {
                    let keychain = KeychainSwift()
                    keychain.set(dictionary["id"] as! String, forKey: kTokenKey)
                }

                DispatchQueue.main.async {
                    completion()
                }
            }
        }) { (error) in
            failure(error!)
        }
    }

    func signUpWithUserName(username: String, password: String, email: String, completion: @escaping (_ result: String) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let networkManager = JUWNetworkManager()
        networkManager.post(url: JUWConfigManager.shared.config.userSingUpURL(), parameters: ["username": username, "password": password, "email": email], completion: { (result) in
            DispatchQueue.global().async {
                if let dictionary = result as? [String: Any] {
                    let keychain = KeychainSwift()
                    if let tokenString = dictionary["id"] as? String {
                        keychain.set(tokenString, forKey: kTokenKey)
                    }
                    else {
                        keychain.set(String(describing: dictionary["id"]), forKey: kTokenKey)
                    }

                    keychain.set(username, forKey: kUserNameKey)
                }

                DispatchQueue.main.async {
                    completion("OK")
                }
            }
        }) { (error) in
            failure(error!)
        }
    }

    func signOut(completion: @escaping (_ success: Bool) -> Void) {
        let keychain = KeychainSwift()
        keychain.delete(kTokenKey)

        completion(true)
    }
}
