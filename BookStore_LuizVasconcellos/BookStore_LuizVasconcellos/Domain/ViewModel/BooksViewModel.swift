//
//  BooksViewModel.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import Foundation
import RxSwift
import RxCocoa

final class BooksViewModel {
    
    // MARK: - Properties
    private var api: APIServiceBookDelegate
    private let maxResults = 20
    private var startIndex = 0
    private var books: [Item] = []
    
    // MARK: - Input & Output
    struct Input {
        let loadScreenObservable: Observable<Void>
        let loadMoreDataObservable: Observable<Void>
    }

    struct Output {
        let booksObservable: Driver<[Item]>
        let loadMoreBooksObservable: Driver<[Item]>
    }
    
    // MARK: - Init
    init(api: APIServiceBookDelegate) {
        self.api = api
    }
    
    // MARK: - Connect
    func connect(input: Input) -> Output {
        let booksObservable = input.loadScreenObservable
            .flatMap { [weak self] _ -> Observable<[Item]> in
                guard let self = self else { return Observable<[Item]>.empty() }
                return Observable<[Item]>.just(self.books)
            }.asDriver(onErrorJustReturn: [])
        
        let loadMoreObservable = input.loadMoreDataObservable
            .flatMapLatest { [weak self] _ -> Observable<[Item]> in
                guard let self = self else { return Observable<[Item]>.empty() }
                
                return self.api.getBooks(maxResults: self.maxResults, startIndex: self.startIndex)
                    .do(onSuccess: { books in
                        self.books.append(contentsOf: books)
                        self.startIndex += self.maxResults
                    })
                    .map {_ in
                        return self.books
                    }
                    .asObservable()
            }.asDriver(onErrorJustReturn: [])
            
        return Output(booksObservable: booksObservable,
                      loadMoreBooksObservable: loadMoreObservable)
    }
}
