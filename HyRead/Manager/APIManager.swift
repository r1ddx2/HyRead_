//
//  APIManager.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import UIKit
import Combine

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
            return NSLocalizedString("Unknown Error", comment: "")
        }
    }
}

// MARK: - APIManager
typealias FutureBookHandler = Future<[Book], Error>

class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    private let urlString = Bundle.valueForString(key: Constant.urlKey)
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() -> FutureBookHandler {
        
        // Future: A publisher that returns <Output, Error>
        return FutureBookHandler { [weak self] promise in
            
            guard let self = self, let url = URL(string: urlString) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            // publisher for URLSession data task, returns (data, URLResponse)
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in         // Check HTTPResponse status code
                    guard let httpResponse = response as? HTTPURLResponse,
                            200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [Book].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in      // Handle errors
                    
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: { data in         // Handle success data
                    promise(.success(data))
                }
                .store(in: &self.cancellables)
        }
    }
    

}


