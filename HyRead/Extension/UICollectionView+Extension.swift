//
//  UICollectionView+Extension.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import UIKit

extension UICollectionView {
    func calculateItemsPerRow(_ itemsPerRow: CGFloat) -> CGSize {
        let padding: CGFloat = 20 * 2
        let minimumItemSpacing: CGFloat = 10 * (itemsPerRow - 1)
        let availableWidth = self.frame.width - padding - minimumItemSpacing
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * 2

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}
