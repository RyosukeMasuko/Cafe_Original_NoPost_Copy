//
//  HomeImage.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/23.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit

class HomeImage {
    var objectId: String
    //var user: User
    var imageUrl: Array<Any>
    var text: String
    var category: String
  
    
    init(objectId: String, imageUrl: Array<Any>, text: String, category: String){
        self.objectId = objectId
        //self.user = user
        self.imageUrl = imageUrl
        self.text = text
        self.category = category
        
    }

}
