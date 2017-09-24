//
//  JUWProduct.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/24/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import UIKit
import RealmSwift

class JUWProduct: Object {
    @objc dynamic var name: String?
    @objc dynamic var updateDate: Date?
    @objc dynamic var identifier: String?
    @objc dynamic var collectionCenter: JUWCollectionCenter?
}
