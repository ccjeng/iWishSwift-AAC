//
//  Category.swift
//  iWishSwift
//
//  Created by andycheng on 2016/10/22.
//  Copyright © 2016年 ccjeng. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    dynamic var id = NSUUID().uuidString
    dynamic var name = ""
    let order = RealmOptional<Int>()
    let items = List<Item>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
