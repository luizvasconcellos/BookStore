//
//  BookmarksViewModel.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 12/12/22.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarksViewModel {
    
    // MARK: - Properties
    var book: Item?
    
    // MARK: - Input & Output
    struct Input {
        let loadScreenObservable: Observable<Void>
    }

    struct Output {
        let buyButtonIsEnabledObservable: Driver<Bool>
    }
    
    // MARK: - Connect
    func connect(input: Input) -> Output {
        
        let isBuyButtonEnabledObservable = input.loadScreenObservable
            .flatMap { [weak self] _ -> Single<Bool> in
                guard let self = self else { return Single.just(false) }
                return Single.just(self.book?.saleInfo.buyLink != nil)
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        return Output(buyButtonIsEnabledObservable: isBuyButtonEnabledObservable)
    }
}

extension BookmarksViewModel {
    
    func saveBookmarks(book: Item) -> (success: Bool, message: String) {
        
        if UserDefaultsManager.shared.isBookmarked(book: book) {
            if UserDefaultsManager.shared.removeFromBookmarks(book: book) {
                return (true, "The Book was removed from your favorite list.")
            }
            return (false, "We had a problem to remove this book from your list, please try again later.")
        }
        if UserDefaultsManager.shared.addToBookmarks(book: book) {
            return (true, "The book was added to your favorite list.")
        }
        return (false, "We had a problem to add this book from your list, please try again later.")
    }
    
    func isBookmared(_ book: Item?) -> Bool {
        
        guard let book = book else { return false }
        return UserDefaultsManager.shared.isBookmarked(book: book)
    }
    
    func bookmarkedItems() -> [Item] {
        UserDefaultsManager.shared.getUserBookmarksList()
    }
}
