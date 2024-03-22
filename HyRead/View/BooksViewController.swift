//
//  ViewController.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/20.
//

import UIKit
import Combine

class BooksViewController: UIViewController {
    
    private var viewModel: BooksViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subviews
    var collectionView: UICollectionView!
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setUpLayouts()
        bindViewModel()
    }
    private func setUpCollectionView() {
        setUpCollectionViewLayout()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
    }
    private func setUpLayouts() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func bindViewModel() {
        viewModel = BooksViewModel(bookManager: BooksManager())
        
        viewModel.$bookList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] books in
                self?.updateUI()
            }
            .store(in: &cancellables)
        //StorageManager.shared.deleteAllData()
       viewModel.fetchBooks()
    }
  
    // MARK: - Methods
    private func updateUI() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension BooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell else { return UICollectionViewCell() }
        
        cell.layoutCell(with: viewModel.bookList[indexPath.row])
        // Subscribe to cell button
        cell.buttonTappedPublisher
            .sink { [weak self] uuid in
                self?.viewModel.updateFavorite(for: uuid)
            }
            .store(in: &cell.cancellables)
        
        return cell
        
    }
    
}

// MARK: - UICollectionView Layout
extension BooksViewController: UICollectionViewDelegateFlowLayout {
    
    private func setUpCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        
        let padding: CGFloat = 20 * 2
        let minimumItemSpacing: CGFloat = 10 * (itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - padding - minimumItemSpacing
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * 2
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}

