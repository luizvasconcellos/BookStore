//
//  BookmarksViewController.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 12/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol BookmarksCoordinatorDelegate: AnyObject {
    func didSelectedBookTapped(_ bookmarksViewController: BookmarksViewController, book: Item)
}

final class BookmarksViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    // MARK: - Properties
    weak var bookmarksCoordinatorDelegate: BookmarksCoordinatorDelegate?
    var bookmarksListViewModel: BookmarksListViewModel?
    private let reuseIdentifier = "Cell"
    private let itemsPerRow: CGFloat = 2
    private let disposeBag = DisposeBag()
    private var books: [Item] = [Item]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self

        setupUI()
        registerCell()
        setupBindings()
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    private func registerCell() {
        
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func setupBindings() {
        
        let input = BookmarksListViewModel.Input(loadScreenObservable: rx.viewWillAppear
            .asObservable()
            .map { _ in
                Void()
            })
        
        let connect = bookmarksListViewModel?.connect(input: input)
        
        connect?.bookmarkedBooksObservable
            .drive(onNext: { [weak self] books in
                self?.books = books
            }).disposed(by: disposeBag)
    }
}

extension BookmarksViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: Collection View Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 2, bottom: 4, right: 2)
    }
}

extension BookmarksViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookCollectionViewCell else { return UICollectionViewCell() }

        let book = books[indexPath.row]
        cell.bookTitle = book.volumeInfo.title
        cell.bookThumbUrl = book.volumeInfo.imageLinks.smallThumbnail
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        
        bookmarksCoordinatorDelegate?.didSelectedBookTapped(self, book: book)
    }
}
