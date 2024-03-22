//
//  FavoritesViewModel.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import UIKit
import Combine

class FavoritesViewModel {
    private let bookManager = BooksManager.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var favBookList: [Book] = [Book]()

    init() {
        bindBookUpdates()
    }

    // MARK: - Methods
    func bindBookUpdates() {
        bookManager.allBookUpdates()
            .receive(on: DispatchQueue.main)
            .map { $0.filter { $0.isFavorite == true } }
            .assign(to: \.favBookList, on: self)
            .store(in: &cancellables)
    }
//    func fetchBooks() {
//        bookManager.fetchBooks()
//            .receive(on: DispatchQueue.main)
//            .map { $0.filter { $0.isFavorite == true } }
//            .sink { [weak self] result in
//                if case let .failure(error) = result {
//
//                    self?.bookManager.loadBooks()
//                    print("🔴Failed to fetch books: \(error.localizedDescription)")
//                }
//            } receiveValue: { [weak self] favBooks in
//                self?.favBookList = favBooks
//            }
//            .store(in: &cancellables)
//    }
    func updateFavorite(for uuid: Int) {
        bookManager.updateFavorite(uuid: uuid)
    }
}
