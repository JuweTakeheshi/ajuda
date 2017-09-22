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

class JUWMapCollectionCenter: NSObject, MKAnnotation {
    let title: String?
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let phoneNumber: String
    let centerIdentifier: String
    let coordinate: CLLocationCoordinate2D

    init(title: String, name: String, address: String, latitude: Double, longitude: Double, phoneNumber: String, identifier: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.phoneNumber = phoneNumber
        self.centerIdentifier = identifier
        self.coordinate = coordinate
        super.init()
    }

    var subtitle: String? {
        return address
    }
}
