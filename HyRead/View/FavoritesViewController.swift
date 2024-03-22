//
//  FavoriteViewController.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController {
    let viewModel = FavoritesViewModel()
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
        navigationItem.title = Constant.myFavTitle
        self.navigationController?.navigationBar.tintColor = .black
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
        viewModel.$favBookList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
    // MARK: - Methods
    private func updateUI() {
        collectionView.reloadData()
    }
}
// MARK: - UICollectionView DataSource
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favBookList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookCollectionViewCell.identifier,
            for: indexPath) as? BookCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layoutCell(with: viewModel.favBookList[indexPath.row])

        // Subscribe to cell button
        cell.eventPublisher
            .receive(on: DispatchQueue.main)
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
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        collectionView.calculateItemsPerRow(3)
    }
}
