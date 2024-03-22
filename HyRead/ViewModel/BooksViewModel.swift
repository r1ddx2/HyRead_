//
//  BooksViewModel.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import UIKit
import Combine


typealias BookPublisher = AnyPublisher<[Book], Error>
typealias BookNeverPublisher = AnyPublisher<[Book], Never>

class BooksViewModel {
    
    private let bookManager: BooksManager!
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var bookList = [Book]()
    
    init(bookManager: BooksManager) {
        self.bookManager = bookManager
        bindBookUpdates()
    }
    
    // MARK: - Methods
    func bindBookUpdates() {
        bookManager.bookUpdates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.bookList, on: self)
            .store(in: &cancellables)
    }
    
    func fetchBooks() {
        
        bookManager.fetchBooks()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if case let .failure(error) = result {
                    // Load Core Data
                    self?.bookManager.loadBooks()
                    print("🔴Failed to fetch books: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] books in
                self?.bookList = books
                // Save to Core Data
                self?.bookManager.saveToStorage(books)
                print("🟢Success fetched books")
            }
            .store(in: &cancellables)
    }
   
    func updateFavorite(for uuid: Int) {
        bookManager.updateFavorite(uuid: uuid)
    }
}
