//
//  Book.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import Foundation
import Combine


struct Book: Codable {
    let uuid: Int
    let title: String
    let coverUrl: String
    let publishDate: String
    let publisher: String
    let author: String
    var isFavorite: Bool?
}
