//
//  CartResponse.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/9/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
struct CartResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:[Item]?
}

struct Item: Decodable{
    var id:Int?
    var product_name:String?
    var product_image:String?
    var quantity:Int?
    var price:String?
    var company:Company?
}
