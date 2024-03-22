//
//  BookCollectionView.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import UIKit

class BookCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(frame: CGRect, layout: UICollectionViewLayout) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.configureFlowLayout()
        self.registerCell()
        self.backgroundColor = .white
    }
    private func configureFlowLayout() {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
    }
    private func registerCell() {
        self.register(
            BookCollectionViewCell.self,
            forCellWithReuseIdentifier: BookCollectionViewCell.identifier
            )
    }
}
