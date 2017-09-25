//
//  JUWCollectionCenter.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit
import RealmSwift

final class JUWCollectionCenter: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var centerIdentifier: String = ""
    @objc dynamic var contactName: String = ""
    @objc dynamic var contactEmail: String = ""
    @objc dynamic var twitterHandle: String = ""
    @objc dynamic var facebookHandle: String = ""
    let products = List<JUWProduct>()
}
