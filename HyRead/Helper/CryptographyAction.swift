//
//  CryptographyAction.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import Foundation
import CryptoKit

enum CryptographyAction: String {
    case encrypt
    case decrypt
    
    var service: CryptoOperationProtocol {
        CryptoKitHelper.shared
    }
    
    func perform(_ text: String, using key: SymmetricKey) -> String? {
           switch self {
           case .encrypt:
               return service.encrypt(text, using: key)
           case .decrypt:
               return service.decrypt(text, using: key)
           }
       }
}
