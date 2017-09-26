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
let kCollectionCentersUrl = "https://hapi.balterbyte.com/api/acopios"
let kCollectionCenterNeedsUrl = "https://hapi.balterbyte.com/api/acopios/%@/productos"
let kCollectionCenterContactInfoUrl = "https://hapi.balterbyte.com/api/acopios/%@/contactos"
let kCollectionCenterSearchProductUrl = "https://hapi.balterbyte.com/api/productos?filter={\"where\":{\"nombre\":{\"like\":\"%@\"}}}"
let kCollectionCenterProductsUrl = "https://hapi.balterbyte.com/api/acopios/%@/productos"

let kCollectionCenterAddProduct = "http://hapi.balterbyte.com:8080/api/acopios/%@/aceptan?access_token=WZy7zHHYJEBTT1RuXzHWFwBkCXeGcinLylUJ8MS27xIJB2wHmmElQoGzBXFBGpIks"

let kTokenKey = "KeyForToken"
let kUserNameKey = "KeyForUserName"
let kUserTypeKey = "KeyForUserType"

