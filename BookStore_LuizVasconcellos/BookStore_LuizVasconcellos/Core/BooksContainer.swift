//
//  BooksContainer.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 08/12/22.
//

import Foundation
import Swinject

class BooksContainer {
    
    let container = Container()
    
    init() {
        
        setup()
    }
    
    private func setup() {
        
        // MARK: - Core
        container.register(NetworkingDelegate.self) { _ in Networking() }
        
        // MARK: - API
        container.register(APIServiceBookDelegate.self) { resolver in
            let networking = resolver.resolve(NetworkingDelegate.self)!
            return APIServiceBook(networking: networking)
        }
        
        // MARK: - ViewModel
        container.register(BooksViewModel.self) { resolver in
            let booksAPI = resolver.resolve(APIServiceBookDelegate.self)
            return BooksViewModel(api: booksAPI!)
        }
        
        container.register(BookmarksViewModel.self) { resolver in
            return BookmarksViewModel()
        }
        
        container.register(BookmarksListViewModel.self) { _ in
            return BookmarksListViewModel()
        }
        
        // MARK: - ViewController
        container.register(HomeCollectionViewController.self) { resolver in
            let controller = HomeCollectionViewController()
            controller.viewModel = resolver.resolve(BooksViewModel.self)
            return controller
        }
    }
}
