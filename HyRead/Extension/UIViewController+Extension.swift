//
//  UIViewController+Extension.swift
//  HyRead
//
//  Created by Red Wang on 2024/3/22.
//

import UIKit

extension UIViewController {
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
        }
}
