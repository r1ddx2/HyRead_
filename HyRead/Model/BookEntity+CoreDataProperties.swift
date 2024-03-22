//
//  BookEntity+CoreDataProperties.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//
//

import Foundation
import CoreData
import CryptoKit

extension BookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }

    @NSManaged public var uuid: Int64
    @NSManaged public var title: String?
    @NSManaged public var publisher: String?
    @NSManaged public var publishDate: String?
    @NSManaged public var coverUrl: String?
    @NSManaged public var author: String?
    @NSManaged public var isFavorite: Bool
   
}

extension BookEntity : Identifiable {
    /// Encrypt or Decrypt Entity
    func convertEntity(
        with key: SymmetricKey,
        do action: CryptographyAction
    ) {
        guard let newTitle = action.perform(title ?? "" , using: key),
              let newCoverUrl = action.perform(coverUrl ?? "" , using: key),
              let newPublishDate = action.perform(publishDate ?? "" , using: key),
              let newPublisher = action.perform(publisher ?? "" , using: key),
              let newAuthor = action.perform(author ?? "" , using: key) else {
            print("🔴Fail to \(action.rawValue) data")
        
           return
        }
        print("🟢Success to \(action.rawValue) data")

        uuid = uuid
        title = newTitle
        coverUrl = newCoverUrl
        publishDate = newPublishDate
        publisher = newPublisher
        author = newAuthor
        isFavorite = isFavorite
    }
    
    //  Map Book to BookEntity
    func mapToEntity(_ book: Book){
        
        uuid = Int64(book.uuid)
        title = book.title
        coverUrl = book.coverUrl
        publishDate = book.publishDate
        publisher = book.publisher
        author = book.author
        isFavorite = book.isFavorite ?? false
        
    }
    
    
     //  Map BookEntity to Book
     func mapToBook() -> Book? {
         
             return Book(
                 uuid: Int(uuid),
                 title: title ?? "",
                 coverUrl: coverUrl ?? "",
                 publishDate: publishDate ?? "",
                 publisher: publisher ?? "",
                 author: author ?? "",
                 isFavorite: isFavorite
             )
        
     }
}
