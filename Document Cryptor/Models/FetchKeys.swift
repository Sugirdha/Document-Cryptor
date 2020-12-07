//
//  FetchKeys.swift
//  Document Cryptor
//
//  Created by Sugirdha on 1/12/20.
//

import Foundation
import RNCryptor

struct FetchKeys {
    
    func randomSaltAndKeyForPassword(password: String) -> (salt: Data, key: Data) {
        let salt = RNCryptor.randomData(ofLength: RNCryptor.FormatV3.saltSize)
        let key = RNCryptor.FormatV3.makeKey(forPassword: password, withSalt: salt)
//        print("salt: \(salt.base64EncodedString())", salt)
//        print("key: \(key.base64EncodedString())", key)
        return (salt, key)
    }
    
}
