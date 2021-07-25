//
//  UserImageUrl.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/12.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit

// 指定URLから画像を読み込み、セットする
// defaultUIImageには、URLからの読込に失敗した時の画像を指定する
extension UIImageView {
    func loadImageAsynchronously(url: URL?, defaultUIImage: UIImage? = nil) -> Void {
        if url == nil {
            self.image = defaultUIImage
            return
        }
        DispatchQueue.global().async {
            do {
                let imageData: Data? = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = defaultUIImage
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.image = defaultUIImage
                }
            }
        }
    }
}

