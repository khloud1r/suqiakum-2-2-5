//
//  User.swift
//  suqiakum
//
//  Created by hany karam on 3/3/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import Foundation

struct Company: Decodable{
    var id:Int?
    var slug:String?
    var name:String?
    var image:String?
    var phone:String?
    var min_amount:Int?
    var min_delivery_amount:Int?
    var has_free_delivery:Int?
    var delivery_price:Int?
    var is_special:Int?
}
struct CompainesResponse:Decodable {
    let status:Bool
    let message:String
    let data: Compaines
}
struct Compaines :Decodable{
    let specail_companies: [Company]
    let companies: [Company]
}
