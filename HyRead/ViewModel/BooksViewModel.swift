//
//  BooksViewModel.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import UIKit
import Combine

class BooksViewModel: ObservableObject {
    private let bookManager = BooksManager()
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var bookList = [Book]()
    
    func fetchBooks() {
        
        bookManager.fetchBooks()
            .receive(on: DispatchQueue.main)
            .sink { completion in       // Handle error
                if case let .failure(error) = completion {
                    print("🔴Failed to fetch books: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] books in      // Handle success
                self?.bookList = books
                print("🟢Received books")
            }
            .store(in: &cancellables)
    }
    
    
    
    
    
    
    
    
    
}
