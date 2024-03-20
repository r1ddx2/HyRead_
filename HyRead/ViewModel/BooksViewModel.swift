//
//  BooksViewModel.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import UIKit
import Combine

class BooksViewModel {
   
    var bookList = [Book]()
    
    private var cancellables = Set<AnyCancellable>()
    
    func getBooks() {
        
        APIManager.shared.fetchData()
            .sink { completion in
                // Failure
                if case .failure(let err) = completion {
                    print(err.localizedDescription)
                }
                // Success
            } receiveValue: { [weak self] data in
                print(data)
                self?.bookList = data
            }
            .store(in: &cancellables)
        
    }
    
    
    
    
    
    
    
    
    
}
