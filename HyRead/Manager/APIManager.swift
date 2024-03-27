//
//  APIManager.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import Combine
import UIKit

// MARK: - NetworkError

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .responseError:
            return NSLocalizedString("Response Error", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown API Error", comment: "")
        }
    }
}

// MARK: - APIManager

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    private let urlString = Bundle.valueForString(key: Constant.urlKey)
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() -> BookPublisher {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        // publisher for URLSession data task, returns (data, URLResponse)
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in // Check HTTPResponse status code
                guard let httpResponse = response as? HTTPURLResponse,
                      200 ... 299 ~= httpResponse.statusCode
                else {
                    throw NetworkError.responseError
                }
                return data
            }
            .decode(type: [Book].self, decoder: JSONDecoder())
            .map { books -> [Book] in // Set isFavorite default to false
                books.map { book in
                    var book = book
                    book.isFavorite = false
                    return book
                }
            }
            .mapError { error -> Error in
                switch error {
                case is DecodingError:
                    return error
                case NetworkError.responseError:
                    return NetworkError.responseError // thrown by tryMap
                default:
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
