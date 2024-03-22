//
//  BooksManager.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import UIKit
import Combine

class BooksManager {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let apiManager = APIManager.shared
    private let storageManager = StorageManager.shared
    
    // MARK: - Methods
    // Fetch API
    func fetchBooks() -> BookPublisher {
        return apiManager.fetchData()
            .eraseToAnyPublisher()
    }
    
    // Load Core Data
    func loadBooks() {
        storageManager.loadAllData()
    }
    
    // Save to Core Data
    func saveToStorage(_ books: [Book]) {
        for book in books {
            storageManager.updateData(book: book)
        }
        loadBooks()
    }
    
    // Update favorite
    func updateFavorite(uuid: Int) {
        storageManager.updateFavorite(for: uuid)
    }
    
    // Pass on to viewModel
    func bookUpdates() -> BookNeverPublisher {
        return storageManager.$bookList
            .eraseToAnyPublisher()
    }
}

