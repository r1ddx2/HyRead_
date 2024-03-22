//
//  BooksViewController.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/20.
//

import Combine
import UIKit

class BooksViewController: UIViewController {
    private let viewModel = BooksViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Subviews
    var collectionView: BookCollectionView!

    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpCollectionView()
        setUpLayouts()
        bindViewModel()
    }
    private func setUpNavigationBar() {
        let rightButton = UIBarButtonItem.buildButton(
            icon: Constant.refreshIcon,
            target: self,
            action: #selector(refreshButtonTapped),
            color: .black
        )
        let leftButton = UIBarButtonItem.buildButton(
            icon: Constant.favoriteIcon,
            target: self,
            action: #selector(favBooksButtonTapped),
            color: .black
        )
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = leftButton
    }
    private func setUpCollectionView() {
        collectionView = BookCollectionView(
            frame: .zero,
            layout: UICollectionViewFlowLayout()
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    private func setUpLayouts() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func bindViewModel() {
        viewModel.$bookList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        viewModel.fetchBooks()
        // StorageManager.shared.deleteAllData()
    }

    // MARK: - Methods
    private func updateUI() {
        collectionView.reloadData()
    }
    @objc private func refreshButtonTapped() {
        viewModel.fetchBooks()
    }
    @objc private func favBooksButtonTapped() {
        let favVC = FavoritesViewController()
        let favBookList = viewModel.bookList.filter { $0.isFavorite == true }
        favVC.viewModel.favBookList = favBookList
        push(favVC)
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension BooksViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.bookList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookCollectionViewCell.identifier,
            for: indexPath) as? BookCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.layoutCell(with: viewModel.bookList[indexPath.row])
        // Subscribe to cell button
        cell.eventPublisher
            .sink { [weak self] uuid in
                self?.viewModel.updateFavorite(for: uuid)
                print("UUID: \(uuid)")
            }
            .store(in: &cell.cancellables)
            // store in vc cancellables will cause memory leak


        return cell
    }
}

// MARK: - UICollectionView FlowLayout
extension BooksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        collectionView.calculateItemsPerRow(3)
    }
}
