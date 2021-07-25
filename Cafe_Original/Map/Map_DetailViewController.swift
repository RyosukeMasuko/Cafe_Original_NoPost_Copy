//
//  Map_DetailViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/15.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB

class MapDetailViewController: UIViewController {

    var nextText : String?
    var nextTitle: String?

    var detailTitle = [String]()
    var detailImage = [String]()
    var detailtext = [String]()

    @IBOutlet var postTextField : UITextField!
    @IBOutlet var postTextView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        postTextField.text = nextText
        postTextView.text = nextTitle

    }




}
