//
//  RatingViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/01.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController{
    
    @IBOutlet var reviewTextField: UITextField!
    @IBOutlet var cosmosStarRating: CosmosView!

    override func viewDidLoad() {
        super.viewDidLoad()

        cosmosStarRating.rating = 3.0
        reviewTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    @objc func endEditing() {
        view.endEditing(true)
    }
}

extension RatingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
