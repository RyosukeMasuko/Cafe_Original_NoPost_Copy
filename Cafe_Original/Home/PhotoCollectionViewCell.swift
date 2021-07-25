//
//  PhotoCollectionViewCell.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/16.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var photoImageView :UIImageView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 角丸にするコード
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true

        layer.cornerRadius = 10
        let nameLabelColor = UIColor.lightGray.withAlphaComponent(0.50)
        nameLabel.backgroundColor = nameLabelColor
    }

}
