//
//  BookCollectionViewCell.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//

import Combine
import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    static let identifier = "\(BookCollectionViewCell.self)"

    var book: Book?
    private let buttonTappedPublisher = PassthroughSubject<Int, Never>()
    var eventPublisher: AnyPublisher<Int, Never> {
        return buttonTappedPublisher.eraseToAnyPublisher()
    }
    var cancellables = Set<AnyCancellable>()

    // MARK: - Subview
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconHeartEmpty), for: .normal)
        return button
    }()

    // MARK: - View Load
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpActions()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // Avoid retain cycle
        cancellables = Set<AnyCancellable>()
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

            favoriteButton.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: -2),
            favoriteButton.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor)
        ])
    }

    private func setUpActions() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    // MARK: - Methods

    func layoutCell(with book: Book) {
        self.book = book
        bookTitleLabel.text = book.title
        coverImageView.loadImage(book.coverUrl)
        updateButtonUI()
    }

    @objc func favoriteButtonTapped() {
        if let book = book {
            buttonTappedPublisher.send(book.uuid)
            self.book?.isFavorite?.toggle()
            updateButtonUI()
        }
    }

    func updateButtonUI() {
        if book?.isFavorite == true {
            favoriteButton.setImage(UIImage(resource: .iconHeartFill), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(resource: .iconHeartEmpty), for: .normal)
        }
    }
}
