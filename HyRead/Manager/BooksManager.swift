//
//  BooksManager.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import UIKit

class BooksManager {
    
    func fetchBooks() -> BookPublisher {
        return APIManager.shared.fetchData()
            .eraseToAnyPublisher()
    }
}
