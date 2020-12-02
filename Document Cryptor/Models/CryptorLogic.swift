//
//  CryptorLogic.swift
//  Document Cryptor
//
//  Created by Sugirdha on 1/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RNCryptor

let dataFilePathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
var fetchKeys = FetchKeys()
var password = String()

struct CryptorLogic {
    
    mutating func setPassword(_ givenPassword: String) {
        password = givenPassword
    }
    
    let (encryptionSalt, encryptionKey) = fetchKeys.randomSaltAndKeyForPassword(password: password)
    let (hmacSalt, hmacKey) = fetchKeys.randomSaltAndKeyForPassword(password: password)
    

    func encrypt(fileToEncrypt: URL) -> String {
        
        guard let fileData = try? Data(contentsOf: fileToEncrypt) else {
            fatalError("Contents of file couldn't be retrieved")
        }
//        print("Have file data: \(String(data: fileData, encoding: .utf8)!)")
        
        let encryptor = RNCryptor.EncryptorV3(encryptionKey: encryptionKey, hmacKey: hmacKey)
        let encryptedData = encryptor.encrypt(data: fileData)
//        let encryptedDataString = encryptedData.base64EncodedString()
//        print("Have encrypted data in String form: \(encryptedDataString)")
                
        let encryptedFile = fileToEncrypt.lastPathComponent
//        guard let encryptedFileUrl = dataFilePathUrl?.appendingPathComponent(encryptedFile) else { return "Error getting file url" }
            
            do {
                try encryptedData.write(to: fileToEncrypt)
//                try encryptedData.write(to: encryptedFileUrl)

            } catch {
                print(error)
            }
        
//        print("Encrypted File path is \(encryptedFileUrl)")

        return encryptedFile
    }
    
    func decrypt(fileToDecrypt: URL) -> String {
        do {
            guard let fileData = try? Data(contentsOf: fileToDecrypt) else {
                fatalError("Contents of file couldn't be retrieved")
            }

            let decryptor = RNCryptor.DecryptorV3(encryptionKey: encryptionKey, hmacKey: hmacKey)
            let decryptedData = try decryptor.decrypt(data: fileData)
            
//            let decryptedDataString = decryptedData.base64EncodedString()
//            print("Have decrypted data in string form: \(decryptedDataString)")
            
            let decryptedFile = fileToDecrypt.lastPathComponent
//            guard let decryptedFileUrl = dataFilePathUrl?.appendingPathComponent(decryptedFile) else { return "Error getting file url" }
            
            do {
                try decryptedData.write(to: fileToDecrypt)
//                try decryptedData.write(to: decryptedFileUrl)

            } catch {
                print(error)
            }
            
//            print("Decrypted file path is \(decryptedFileUrl)")

            return decryptedFile
        } catch {
            return "Error Decrypting"
        }
    }
    

}
