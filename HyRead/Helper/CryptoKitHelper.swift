//
//  CryptoKitHelper.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import Foundation
import CryptoKit

protocol CryptoOperationProtocol {
    func encrypt(_ text: String, using key: SymmetricKey) -> String?
    func decrypt(_ text: String, using key: SymmetricKey) -> String?
}

class CryptoKitHelper: CryptoOperationProtocol {
    
    static let shared = CryptoKitHelper()
    private init() {}

    // Encrypt messages with a key using AES.GCM
    func encrypt(_ text: String, using key: SymmetricKey) -> String? {
        // Convert the message to data
        guard let data = text.data(using: .utf8) else { return nil }
        // Seal the message with the key
        let sealedBox = try? AES.GCM.seal(data, using: key)
        // Return the sealed box as a base64 encoded string
        return sealedBox?.combined?.base64EncodedString()
    }
    
    func decrypt(_ encryptedText: String, using key: SymmetricKey) -> String? {
        guard let data = Data(base64Encoded: encryptedText),
              let sealedBox = try? AES.GCM.SealedBox(combined: data),
              let decryptedData = try? AES.GCM.open(sealedBox, using: key),
              let decryptedString = String(data: decryptedData, encoding: .utf8) else { return nil
        }
        return decryptedString
    }
    
}
