//
//  ViewController.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/20.
//

import UIKit

class BooksViewController: UIViewController {

    // MARK: - Subviews
    var collectionView: UICollectionView!
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setUpLayouts()
    }
    func setUpCollectionView() {
        setUpCollectionViewLayout()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
    }
    func setUpLayouts() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    // MARK: - Methods

}

// MARK: - UICollectionView DataSource & Delegate
extension BooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
        
    }
    
}

extension BooksViewController: UICollectionViewDelegate {
    
    
}

// MARK: - UICollectionView Layout
extension BooksViewController: UICollectionViewDelegateFlowLayout {
    
    func setUpCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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

