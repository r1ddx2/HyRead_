//
//  UIBarButtonItem+Extension.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import UIKit

extension UIBarButtonItem {
    static func buildButton(
        icon systemName: String,
        target: Any?,
        action: Selector?,
        color: UIColor
    ) -> UIBarButtonItem {
        let button = UIBarButtonItem(
            image: UIImage(systemName: systemName),
            style: .plain,
            target: target,
            action: action
        )
        button.tintColor = .black
        return button
    }
}
