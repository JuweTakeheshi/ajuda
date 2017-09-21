//
//  JUWKeychainService.swift
//  Ajuda
//
//  Created by Juwe Takeheshi on 9/21/17.
//  Based on https://stackoverflow.com/questions/37539997/save-and-load-from-keychain-swift
//  Copyright © 2017 Juwe Takeheshi. All rights reserved.
//
import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"

/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let tokenKey = "KeyForToken"
let userTypeKey = "KeyForUserType"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class JUWKeychainService: NSObject {
    
    /**
     * Exposed methods to perform save and load queries.
     */

    public class func saveToken(token: NSString) {
        self.save(service: tokenKey as NSString, data: token)
    }

    public class func loadToken() -> NSString? {
        return self.load(service: tokenKey as NSString)
    }

    public class func saveUserType(type: NSString) {
        self.save(service: userTypeKey as NSString, data: type)
    }
    
    public class func loadUserType() -> NSString? {
        return self.load(service: userTypeKey as NSString)
    }

    /**
     * Internal methods for querying the keychain.
     */
    
    private class func save(service: NSString, data: NSString) {
        let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private class func load(service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}
