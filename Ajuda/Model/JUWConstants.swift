//
//  JUWConstants.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//

import Foundation

let kDefaultEndpoint = "http://hapi.balterbyte.com"
let kConfigUrl = "something"
let kUserAuthenticationUrl = "http://hapi.balterbyte.com:8080/api/voluntarios/login"
let kUserCreationUrl = "http://hapi.balterbyte.com:8080/api/voluntarios"
let kCollectionCentersUrl = "http://hapi.balterbyte.com:8080/api/acopio?access_token=%@s"
let kCollectionCenterNeedsUrl = "http://hapi.balterbyte.com:8080/api/acopios/%@/productos?access_token=%@"
let kCollectionCenterContactInfoUrl = "http://hapi.balterbyte.com:8080/api/acopios/%@/contactos?access_token=%@"
let kCollectionCenterSearchProductUrl = "http://hapi.balterbyte.com:8080/api/productos?filter={\"where\":{\"nombre\":{\"like\":\"%@\"}}}?access_token=%@"
let kCollectionCenterAddProduct = "http://hapi.balterbyte.com:8080/api/acopios/%@/aceptan?access_token=%@"

let kTokenKey = "KeyForToken"
let kUserNameKey = "KeyForUserName"
let kUserTypeKey = "KeyForUserType"

