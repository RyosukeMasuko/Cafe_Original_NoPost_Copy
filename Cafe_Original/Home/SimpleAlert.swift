//
//  SimpleAlert.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/17.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit

struct SimpleAlert {
    static func showAlert(viewController: UIViewController, title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
