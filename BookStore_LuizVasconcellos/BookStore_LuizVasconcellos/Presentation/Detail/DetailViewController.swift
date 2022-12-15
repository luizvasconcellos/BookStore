//
//  DetailViewController.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var detailView: DetailView = {
        let view = DetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Properties
    var bookmarksViewModel: BookmarksViewModel?
    private let disposeBag = DisposeBag()
    private let bookmarkImage = UIImage(systemName: "bookmark")
    private let bookmarkFilledImage = UIImage(systemName: "bookmark.fill")
    
    private var book: Item? {
        didSet {
            self.title = book?.volumeInfo.title
            detailView.bookTitle = book?.volumeInfo.title
            detailView.bookAuthor = book?.volumeInfo.authors.joined(separator: ", ")
            detailView.bookDescription = book?.volumeInfo.volumeInfoDescription
            detailView.bookThumbUrl = book?.volumeInfo.imageLinks.smallThumbnail
        }
    }
    var bookSelected: Item? {
        didSet {
            book = bookSelected
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(filterButtonAction))
        navigationItem.rightBarButtonItem?.image = (bookmarksViewModel?.isBookmared(book) ?? false) ? bookmarkFilledImage : bookmarkImage
        
        setupUI()
        setupBindings()
    }

    // MARK: - Private Functions
    private func setupUI() {

        view.backgroundColor = .systemBackground
        view.addSubview(detailView)

        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        
        detailView.buyButtonTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.openBuyLink()
            })
            .disposed(by: disposeBag)
        
        let input = BookmarksViewModel.Input(loadScreenObservable: rx.viewDidAppear.asObservable().map { _ in Void() })
        
        let connect = bookmarksViewModel?.connect(input: input)
        
        connect?.buyButtonIsEnabledObservable
            .drive(detailView.buyButtonIsEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc private func filterButtonAction() {

        guard let book = book else { return }
        if let bookmarks = bookmarksViewModel?.saveBookmarks(book: book) {
            if bookmarks.success {
                if navigationItem.rightBarButtonItem?.image == bookmarkImage {
                    navigationItem.rightBarButtonItem?.image = bookmarkFilledImage
                } else {
                    navigationItem.rightBarButtonItem?.image = bookmarkImage
                }
            }
            ToastMessage.show(message: bookmarks.message, position: .bottom, type: bookmarks.success ? .success : .error)
        }
    }
}

extension DetailViewController {
    
    func openBuyLink() {
        
        if let buyUrl = book?.saleInfo.buyLink,
           let url = URL(string: buyUrl) {
            UIApplication.shared.open(url)
        }
    }
}
