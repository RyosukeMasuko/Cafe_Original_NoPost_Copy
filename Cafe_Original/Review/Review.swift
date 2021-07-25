//
//  Review.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/01.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit

class Review{
    
    var objectId: String
    var user: User
    var reviewText: String
    var createDate: Date
    var reviewRating: Double
    
    init(objectId: String,user: User, reviewText: String, createDate: Date, reviewRating: Double) {
        self.objectId = objectId
        self.user = user
        self.reviewText = reviewText
        self.createDate = createDate
        self.reviewRating = reviewRating
    }

}
