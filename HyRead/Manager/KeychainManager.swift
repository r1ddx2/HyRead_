//
//  KeychainManager.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import CryptoKit
import Foundation
import Security

enum KeychainManager {
    private static let keyName = Bundle.valueForString(key: Constant.keychainName)

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
        let query: [String: Any] = [
            // the class of the item to be added
            kSecClass as String: kSecClassKey,
            // tag that uniquely identifies the key
            kSecAttrApplicationTag as String: tag,
            // saved data (symmetric key)
            kSecValueData as String: keyData,
            kSecAttrKeyClass as String: kSecAttrKeyClassSymmetric,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        // Add to keychain and returns status of operation
        return SecItemAdd(query as CFDictionary, nil)
    }

    static func getKey(keyName: String) -> SymmetricKey? {
        let tag = keyName.data(using: .utf8)!
        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            // should return data of key
            kSecReturnData as String: true,
            kSecAttrKeyClass as String: kSecAttrKeyClassSymmetric
        ]
        var item: CFTypeRef?
        // Retrieve key from keychain
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == noErr, let keyData = item as? Data else { return nil }
        return SymmetricKey(data: keyData)
    }
}
