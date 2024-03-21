//
//  KingFisherWrapper.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/21.
//


import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        guard let urlString = urlString else { return }
        let url = URL(string: urlString)
        kf.setImage(with: url, placeholder: placeHolder)
    }
}
