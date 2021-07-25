//
//  CafeInfo.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/29.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB

class CafeInfo{
    var objectId: String
    var basicInfo: String
    var introduction: String
    var money: String
    var phoneNumber: String
    var time: String
    var web: String
    var text: String
    var imageUrl: Array<Any>
    var streetAdress: String
    var gone: Bool?
    var wantToGo: Bool?
    var geoPoint: NCMBGeoPoint
    var category: String
    
    init(objectId: String, basicInfo: String,introduction: String,money: String, phoneNumber: String,time: String, web: String, text: String ,imageUrl: Array<Any> ,streetAdress: String, geoPoint: NCMBGeoPoint, category: String){
        self.objectId = objectId
        self.basicInfo = basicInfo
        self.introduction = introduction
        self.money = money
        self.phoneNumber = phoneNumber
        self.time = time
        self.web = web
        self.text = text
        self.imageUrl = imageUrl
        self.streetAdress = streetAdress
        self.geoPoint = geoPoint
        self.category = category
    }

}
