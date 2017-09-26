//
//  JUWConstants.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import Foundation

let kUserAuthenticationUrl = "http://hapi.balterbyte.com:8080/api/voluntarios/login"
let kUserCreationUrl = "http://hapi.balterbyte.com:8080/api/voluntarios"
let kCollectionCentersUrl = "http://hapi.balterbyte.com:8080/api/acopios"
let kCollectionCenterNeedsUrl = "http://hapi.balterbyte.com:8080/api/acopios/%@/productos"
let kCollectionCenterContactInfoUrl = "http://hapi.balterbyte.com:8080/api/acopios/%@/contactos"
let kCollectionCenterSearchProductUrl = "http://hapi.balterbyte.com:8080/api/productos?filter={\"where\":{\"nombre\":{\"like\":\"%@\"}}}"
let kCollectionCenterAddProduct = "http://hapi.balterbyte.com:8080/api/acopios/%@/aceptan?access_token=%@"

let kTokenKey = "KeyForToken"
let kUserNameKey = "KeyForUserName"
let kUserTypeKey = "KeyForUserType"

