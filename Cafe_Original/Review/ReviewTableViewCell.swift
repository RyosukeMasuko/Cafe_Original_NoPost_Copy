//
//  ReviewTableViewCell.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/01.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import Cosmos
import NCMB


class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var reviewCosmosView: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 角丸にするコード
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    
}
