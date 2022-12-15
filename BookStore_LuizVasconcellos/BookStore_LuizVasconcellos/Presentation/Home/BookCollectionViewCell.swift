//
//  BookCollectionViewCell.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 07/12/22.
//

import UIKit
import RxSwift
import RxCocoa

final class BookCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var bookImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    // MARK: - Properties
    var bookTitle: String? {
        didSet {
            bookTitleLabel.text = bookTitle
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
        
        self.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(bookImage)
        containerView.addSubview(bookTitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            bookImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            bookImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            bookImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            
            bookTitleLabel.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 8),
            bookTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            bookTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            bookTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
        ])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
