//
//  DetailView.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailView: UIView {

    // MARK: - UI Elements
    private lazy var bookImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .top
        view.distribution = .fillProportionally
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = view.font.withSize(16)
        view.textColor = .darkGray
        
        return view
    }()
    
    private lazy var authorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = view.font.withSize(12)
        view.textColor = .systemGray4
        
        return view
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var buyButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.setTitle("Buy", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.setTitle("Out of stock", for: .disabled)
        view.setTitleColor(UIColor.darkGray, for: .disabled)
        
        return view
    }()
    
    // MARK: - Properties
    var bookTitle: String? {
        didSet {
            titleLabel.text = bookTitle
        }
    }
    
    var bookThumbUrl: String? {
        didSet {
            if let thumb = bookThumbUrl,
               let url = URL(string: thumb) {
                bookImage.download(from: url)
            }
        }
    }
    
    var bookDescription: String? {
        didSet {
            descriptionTextView.text = bookDescription
        }
    }
    
    var bookAuthor: String? {
        didSet {
            authorLabel.text = bookAuthor
        }
    }
    
    var buyButtonIsEnabled: Binder<Bool> {
        buyButton.rx.isEnabled
    }
    
    var buyButtonTapped: Observable<Void> {
        buyButton.rx.tap.asObservable()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(authorLabel)
        
        self.addSubview(bookImage)
        self.addSubview(stack)
        self.addSubview(descriptionTextView)
        self.addSubview(buyButton)
        
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            bookImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 0),
            
            descriptionTextView.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            buyButton.heightAnchor.constraint(equalToConstant: 45),
            buyButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            buyButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            buyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            buyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}
