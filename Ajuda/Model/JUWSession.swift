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
    let userTypes = [UserType.biker, UserType.motoBiker, UserType.motorizedCar, UserType.shelter, UserType.collectionCenter]

    enum UserType: String {
        case biker = "Ciclista"
        case motoBiker = "Motociclista"
        case motorizedCar = "Conductor"
        case shelter = "Refugio"
        case collectionCenter = "Centro de acopio"
    }

    func isValid() -> Bool {
        return true
    }

    func signInWithUserName(username: String, password: String, completion: (_ result: String) -> Void, failure: (_ error: Error) -> Void) {
        JUWKeychainService.saveToken(token: "obtainedTokenFromServer")
        JUWKeychainService.saveUserType(type: "Ciclista")
        completion("OK")
    }

    func signUpWithUserName(username: String, password: String, userType: String, completion: @escaping (_ result: String) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let networkManager = JUWNetworkManager()
        networkManager.post(parameters: ["username": username, "password": password, "userType": userType], completion: { (result) in
            JUWKeychainService.saveToken(token: "obtainedTokenFromServer")
            JUWKeychainService.saveUserType(type: userType as NSString)
            completion("OK")
        }) { (error) in
            failure(error!)
        }
    }
}
