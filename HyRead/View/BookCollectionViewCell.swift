//
//  BookCollectionViewCell.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    static let identifier = "\(BookCollectionViewCell.self)"
    var uuid: Int?
    var isFavorite: Bool = false
    
    // MARK: - Subview
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconHeartEmpty), for: .normal)
        return button
    }()
    
    //MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpActions()
    }
    private func setUpLayouts() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(bookTitleLabel)
        contentView.addSubview(favoriteButton)
        
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 180),

            bookTitleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
            bookTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: 3),
            favoriteButton.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: -4),
            favoriteButton.widthAnchor.constraint(equalToConstant: 35),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor)
        ])
    }
    private func setUpActions() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    //MARK: - Methods
    func layoutCell(with book: Book) {
        bookTitleLabel.text = book.title
        coverImageView.loadImage(book.coverUrl)
        isFavorite = book.isFavorite ?? false
    }
    @objc func favoriteButtonTapped() {
        isFavorite.toggle()
        updateButtonUI()
        
        // Change data in storage
        
    }
    func updateButtonUI() {
        if isFavorite {
            favoriteButton.setImage(UIImage(resource: .iconHeartFill), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(resource: .iconHeartEmpty), for: .normal)
        }
            
    }
}

