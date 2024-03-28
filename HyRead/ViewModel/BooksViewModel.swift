//
//  BooksViewModel.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import Combine
import UIKit

typealias BookPublisher = AnyPublisher<[Book], Error>
typealias BookNeverPublisher = AnyPublisher<[Book], Never>

class BooksViewModel {
    private let bookManager = BooksManager.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var bookList: [Book] = .init()

    init() {
        bindBookUpdates()
    }

    // MARK: - Methods
    func bindBookUpdates() {
        bookManager.allBookUpdates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.bookList, on: self)
            .store(in: &cancellables)
    }
    func fetchBooks() {
        bookManager.fetchBooks()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if case let .failure(error) = result {
                    // Network connection fail so load Core Data
                    self?.bookManager.loadBooks()
                    print("🔴Failed to fetch books: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] books in
                self?.bookList = books
                // Fetched and Save to Core Data
                self?.bookManager.saveToStorage(books)
            }
            .store(in: &cancellables)
    }
    func updateFavorite(for uuid: Int) {
        bookManager.updateFavorite(uuid: uuid)
    }
}
