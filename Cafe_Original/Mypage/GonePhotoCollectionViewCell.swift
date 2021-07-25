//
//  GonePhotoCollectionViewCell.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/04.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit

//このプロトコル宣言で、セルの中のボタンの処理を他のビューコントローラーに書けるようになる
protocol GonePhotoCollectionViewCellDelegate {
    func didTapGoneButton(collectionViewCell: UICollectionViewCell, button: UIButton)
}


class GonePhotoCollectionViewCell: UICollectionViewCell {
    
    var delegate: GonePhotoCollectionViewCellDelegate?
    @IBOutlet var photoImageView :UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var goneButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 角丸にするコード
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true

        layer.cornerRadius = 10
        
        let nameLabelColor = UIColor.lightGray.withAlphaComponent(0.50)
        nameLabel.backgroundColor = nameLabelColor
        
    }
    
    @IBAction func gone(button: UIButton){
        self.delegate?.didTapGoneButton(collectionViewCell: self, button: button)
    }
    

}
