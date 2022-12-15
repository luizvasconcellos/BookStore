//
//  UserDefaultsManager.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 12/12/22.
//

import Foundation

private struct UserDefaultsKeys {
    
    static let bookmarks = "Bookmarks"
}

final class UserDefaultsManager {
    
    // MARK: - Properties
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Public Functions
    func getUserBookmarksList() -> [Item] {
        
        do {
            let bookmarksList  = try defaults.getObject(forKey: UserDefaultsKeys.bookmarks, castTo: [Item].self)
            return bookmarksList.sorted(by: { $0.volumeInfo.title < $1.volumeInfo.title })
        } catch {
            print(error.localizedDescription)
        }
        return []
    }

    func isBookmarked(book: Item) -> Bool {
        
        return getUserBookmarksList().contains { $0.id == book.id }
    }

    func addToBookmarks(book: Item) -> Bool {
        
        var bookmarksList = getUserBookmarksList()
        bookmarksList.append(book)
        do {
            try defaults.setObject(bookmarksList, forKey: UserDefaultsKeys.bookmarks)
            return true
        } catch {
            print (error.localizedDescription)
        }
        return false
    }

    func removeFromBookmarks(book: Item) -> Bool {
        
        var bookmarksList = getUserBookmarksList()
        guard let index = bookmarksList.firstIndex( where: { $0.id == book.id } ) else  { return false }
        bookmarksList.remove(at: index)
        do {
            try defaults.setObject(bookmarksList, forKey: UserDefaultsKeys.bookmarks)
            return true
        } catch {
            print (error.localizedDescription)
        }
        return false
    }
}
