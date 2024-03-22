//
//  Bundle+Extension.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import Foundation

extension Bundle {
    static func valueForString(key: String) -> String {
        Bundle.main.infoDictionary![key] as! String
    }
}
