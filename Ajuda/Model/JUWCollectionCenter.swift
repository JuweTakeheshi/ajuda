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

    /*
     BACKEND MODEL
     "id": 1,
     "nombre": "Beyork Loreto",
     "direccion": "Calle Altamirano 46 Local 6. San Ángel. Alvaro Obregon. Ciudad de México",
     "latitud": 19.3396421,
     "longitud": -99.1945749,
     "status": "1",
     "responsables": [{
     "id": 1,
     "nombre": "Abraham Magaña",
     "telefono": "5565786799",
     "email": "",
     "twitter": "",
     "facebook": "",
     "CentroDeAcopioResponsables": {
     "centro_de_acopio_id": 1,
     "responsable_id": 1
     }
     }]*/
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
}
