//
//  KeychainManager.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import Foundation
import Security
import CryptoKit

class KeychainManager {
    static private let keyName = Bundle.valueForString(key: Constant.keychainName)

    static var cryptoKey: SymmetricKey? {
        // Check for existing key
        if let existingKey = KeychainManager.getKey(keyName: keyName) {
            return existingKey
        } else {
            // Create key to save to Keychain
            let key = SymmetricKey(size: .bits256)
            let status = KeychainManager.saveToKeychain(key: key, keyName: keyName)
            if status == errSecSuccess {
                return key
            } else {
                print(status)
                return nil
            }
        }
    }
    // MARK: - Methods
    static func saveToKeychain(key: SymmetricKey, keyName: String) -> OSStatus {
        let tag = keyName.data(using: .utf8)!
        let keyData = key.withUnsafeBytes {
            Data(Array($0))
        }
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecValueData as String: keyData,
                                       kSecAttrKeyClass as String: kSecAttrKeyClassSymmetric,
                                       kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked]
  
        return SecItemAdd(query as CFDictionary, nil)
    }

    static func getKey(keyName: String) -> SymmetricKey? {
        let tag = keyName.data(using: .utf8)!
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecReturnData as String: true,
                                       kSecAttrKeyClass as String: kSecAttrKeyClassSymmetric]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == noErr, let keyData = item as? Data else { return nil }
        return SymmetricKey(data: keyData)
    }
}
