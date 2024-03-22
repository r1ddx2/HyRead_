//
//  Book.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import Combine
import Foundation

struct Book: Codable {
    let uuid: Int
    let title: String
    let coverUrl: String
    let publishDate: String
    let publisher: String
    let author: String
    var isFavorite: Bool?
}
