//
//  HomeCollectionViewController.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeCoordinatorDelegate: AnyObject {
    func homeCollectionViewControllerDidTapFavorite(_ viewController: HomeCollectionViewController)
    func homeCollectionViewControllerDidSelectBook(_ viewController: HomeCollectionViewController, book: Item)
}

final class HomeCollectionViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    // MARK: - Properties
    weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?
    var viewModel: BooksViewModel?
    private let reuseIdentifier = "Cell"
    private let itemsPerRow: CGFloat = 2
    private let disposeBag = DisposeBag()
    private var books: [Item] = [Item]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var loadMoreBooks = PublishSubject<Void>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "iOS Books"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Saved", style: .plain, target: self, action: #selector(filterButtonAction))

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
    
    @objc private func filterButtonAction() {

        homeCoordinatorDelegate?.homeCollectionViewControllerDidTapFavorite(self)
    }
}

extension HomeCollectionViewController {
    
    private func registerCell() {
        
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func setupBindings() {
        
        let input = BooksViewModel.Input(loadScreenObservable: rx.viewWillAppear
            .asObservable()
            .map { _ in
                Void()
            },
                                         loadMoreDataObservable: loadMoreBooks.asObservable())
        
        let connect = viewModel?.connect(input: input)
        
        connect?.booksObservable
            .drive(onNext: { [weak self] books in
                self?.books = books
            }).disposed(by: disposeBag)
        
        connect?.loadMoreBooksObservable
            .drive(onNext: { [weak self] books in
                self?.books = books
            }).disposed(by: disposeBag)
    }
}

extension HomeCollectionViewController {
    
    // MARK: - ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if (distanceFromBottom < height) {
            loadMoreBooks.onNext(Void())
        }
    }
}

//MARK: Collection View Layout
extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(itemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(itemsPerRow))
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

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension HomeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        homeCoordinatorDelegate?.homeCollectionViewControllerDidSelectBook(self, book: book)
    }
}
