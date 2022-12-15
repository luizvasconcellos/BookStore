//
//  BookmarksListViewModel.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 13/12/22.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarksListViewModel {
    
    // MARK: - Input & Output
    struct Input {
        let loadScreenObservable: Observable<Void>
    }

    struct Output {
        let bookmarkedBooksObservable: Driver<[Item]>
    }

    // MARK: - Connect
    func connect(input: Input) -> Output {
        
        let booksObservable = input.loadScreenObservable
            .flatMap { _ -> Observable<[Item]> in
                return Observable<[Item]>.just(UserDefaultsManager.shared.getUserBookmarksList())
            }
            
        return Output(bookmarkedBooksObservable: booksObservable.asDriver(onErrorJustReturn: []))
    }
}
