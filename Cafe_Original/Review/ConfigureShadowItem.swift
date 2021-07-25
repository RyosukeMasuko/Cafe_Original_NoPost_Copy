//
//  ConfigureShadowItem.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/11.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit

class ConfigureShadowItem {
  static func imageView(shadowImageView: UIImageView) {
    shadowImageView.layer.shadowColor = UIColor.black.cgColor
    shadowImageView.layer.shadowOpacity = 0.2 // 透明度
    shadowImageView.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
    shadowImageView.layer.shadowRadius = 5 // ぼかし量
  }
  static func button(shadowButton: UIButton) {
    shadowButton.layer.shadowColor = UIColor.black.cgColor
    shadowButton.layer.shadowOpacity = 0.2 // 透明度
    shadowButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
    shadowButton.layer.shadowRadius = 5 // ぼかし量
  }
}
