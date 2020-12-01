//
//  FetchKeys.swift
//  Document Cryptor
//
//  Created by Sugirdha on 1/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import RNCryptor

struct FetchKeys {
    
    func randomSaltAndKeyForPassword(password: String) -> (salt: Data, key: Data) {
        let salt = RNCryptor.randomData(ofLength: RNCryptor.FormatV3.saltSize * 2)
        let key = RNCryptor.FormatV3.makeKey(forPassword: password, withSalt: salt)
//        print("salt: \(salt.base64EncodedString())", salt)
//        print("key: \(key.base64EncodedString())", key)
        return (salt, key)
    }
    
}
