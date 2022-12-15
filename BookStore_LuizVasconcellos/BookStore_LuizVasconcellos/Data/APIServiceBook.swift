//
//  APIServiceBook.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import Foundation
import RxSwift

private struct Endpoint {
    
    static let volumes = "/books/v1/volumes"
}

enum BookServiceError: Error {
    
    case someError
}

protocol APIServiceBookDelegate {
    
    func getBooks(maxResults: Int, startIndex: Int) -> Single<[Item]>
}

final class APIServiceBook {
    
    private var networking: NetworkingDelegate
    private var baseURL = "https://www.googleapis.com/"
    
    init(networking: NetworkingDelegate) {
        
        self.networking = networking
    }
}

extension APIServiceBook: APIServiceBookDelegate {
    
    func getBooks(maxResults: Int, startIndex: Int) -> Single<[Item]> {
        
        Single.create { [weak self] observer in
            
            if let url = URL(string: "\(self?.baseURL ?? "")\(Endpoint.volumes)?q=iOS&maxResults=\(maxResults)&startIndex=\(startIndex)") {
                let request = NetworkRequest(method: .get, url: url)
                self?.networking.baseRequest(request: request, type: BooksResponse.self, completion: { books, error in
                    guard let books = books?.items else {
                        observer(.success([]))
//                        observer(.error(BookServiceError.someError))
                        return
                    }
                    observer(.success(books))
                })
            }
            
            return Disposables.create()
        }
    }
}
