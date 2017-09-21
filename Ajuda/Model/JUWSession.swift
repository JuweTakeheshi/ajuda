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

    enum UserType: String {
        case biker = "biker"
        case motorizedCar = "motorizedCar"
        case shelter = "shelter"
    }

    func isValid() -> Bool {
        return true
    }
}
