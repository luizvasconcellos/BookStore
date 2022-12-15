//
//  BookStoreCoordinator.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 12/12/22.
//

import UIKit

final class BookStoreCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator]
    var rootViewController: UIViewController
    var navigationController: UINavigationController
    
    private var presentingViewController: UIViewController?
    private let booksViewModel = BooksContainer().container.resolve(BooksViewModel.self)
    private let bookmarksViewModel = BooksContainer().container.resolve(BookmarksViewModel.self)
    private let bookmarksListViewModel = BooksContainer().container.resolve(BookmarksListViewModel.self)
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        
        self.childCoordinators = []
        self.rootViewController = navigationController
        self.navigationController = navigationController
    }
    
    // MARK: - Start
    func start() {
        
        let vc = HomeCollectionViewController()
        vc.viewModel = booksViewModel
        vc.homeCoordinatorDelegate = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private Functions
    private func presentDetail(book: Item?) {
        
        let vc = DetailViewController()
        bookmarksViewModel?.book = book
        vc.bookmarksViewModel = bookmarksViewModel
        vc.bookSelected = book
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func presentBookmarks() {
        
        let vc = BookmarksViewController()
        vc.bookmarksListViewModel = bookmarksListViewModel
        vc.bookmarksCoordinatorDelegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - HomeCollectionViewController Delegate
extension BookStoreCoordinator: HomeCoordinatorDelegate {
    
    func homeCollectionViewControllerDidTapFavorite(_ viewController: HomeCollectionViewController) {
        presentBookmarks()
    }
    
    func homeCollectionViewControllerDidSelectBook(_ viewController: HomeCollectionViewController, book: Item) {
        presentDetail(book: book)
    }
}

// MARK: - BookmarksViewContrlled Delegate
extension BookStoreCoordinator: BookmarksCoordinatorDelegate {
    
    func didSelectedBookTapped(_ bookmarksViewController: BookmarksViewController, book: Item) {
        presentDetail(book: book)
    }
}
