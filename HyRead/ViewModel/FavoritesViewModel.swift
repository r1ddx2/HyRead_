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

    @Published var favBookList: [Book] = .init()

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
    func updateFavorite(for uuid: Int) {
        bookManager.updateFavorite(uuid: uuid)
    }
}
