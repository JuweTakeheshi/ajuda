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
    let userTypes = [UserType.biker, UserType.motorizedCar, UserType.shelter]

    enum UserType: String {
        case biker = "biker"
        case motorizedCar = "motorizedCar"
        case shelter = "shelter"
    }

    func isValid() -> Bool {
        return true
    }

    func signInWithUserName(username: String, password: String, completion: (_ result: String) -> Void) {
        
            completion("OK")
    }
}
