//
//  User.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/01.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?
    
    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
}
