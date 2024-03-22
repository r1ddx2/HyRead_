//
//  StorageManager.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import UIKit
import CryptoKit
import Combine
import CoreData

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private var cancellables = Set<AnyCancellable>()

    private let key = KeychainManager.cryptoKey
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    @Published var bookList = [Book]()
    
    // MARK: - Methods
    /// Fetch all data
    func loadAllData() {
        
        guard let key = key else {
            print("🔴Fail to retrieve encryption key")
            return
        }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
       
            do {
                // Fetch data
               let bookEntities = try self.context.fetch(fetchRequest)
                    // Decryption
                    bookEntities.forEach { $0.convertEntity(with: key, do: .decrypt)}
                
                    // Notify subscribers
                    self.bookList = bookEntities.compactMap{ $0.mapToBook() }
                
                    // Encryption
                    bookEntities.forEach { $0.convertEntity(with: key, do: .encrypt) }
            
            } catch {
                print("🔴Fail to load data")
            }
        }

    /// After fetching API, update or add new book

    func updateData(book: Book) {
        guard let key = key else {
            print("🔴Fail to retrieve encryption key")
            return
        }
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            
        do {
            let entities = try context.fetch(fetchRequest)
          
            if let entity = entities.first(where: { $0.uuid == Int16(book.uuid) }) {
                updateBook(existEntity: entity, book: book, with: key)
            } else{
                // Add new book
                addNewBook(book: book, with: key)
            }
            saveToCoreData()
        } catch {
            print("🔴Failed to fetch book with: \(book.uuid)")
        }
        
    }
    /// Update book
    private func updateBook(existEntity: BookEntity, book: Book, with key: SymmetricKey) {
        existEntity.title = book.title
        existEntity.coverUrl = book.coverUrl
        existEntity.publisher = book.publisher
        existEntity.publishDate = book.publishDate
        existEntity.author = book.author
        existEntity.convertEntity(with: key, do: .encrypt)
    }
    
    /// Add new books
    private func addNewBook(book: Book, with key: SymmetricKey) {
        let bookEntity = BookEntity(context: context)
        bookEntity.mapToEntity(book)                    // 1. Map to BookEntity
        bookEntity.convertEntity(with: key, do: .encrypt)  // 2. Encrypt BookEntity
    }
    
    /// Update favorite status for book
    func updateFavorite(for uuid: Int) {
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            
        do {
            let entities = try context.fetch(fetchRequest)
          
            if let entity = entities.first(where: { $0.uuid == Int64(uuid) }) {
                entity.isFavorite.toggle()
                saveToCoreData()
            }
           
        } catch {
            print("🔴Failed to update favorite status for book with UUID: \(uuid)")
        }
    }
    
    /// Delete all data
    func deleteAllData() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "BookEntity")
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print(error)
        }
    }
    
    /// Save to Core Data
    private func saveToCoreData() {
        do {
            try context.save()
        } catch {
            print("🔴Failed to save to core data: \(error)")
        }
    }
}

