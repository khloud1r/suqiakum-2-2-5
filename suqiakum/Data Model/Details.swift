//
//  Details.swift
//  suqiakum
//
//  Created by hany karam on 3/3/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import Foundation
struct DetailsResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:DataResponse?
}

struct WishlistResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:[Details]?
}

struct DataResponse: Decodable{
    var data:[Details]?
}

struct Details: Decodable{
    var id:Int?
    var company_id:Int?
    var name:String?
    var description:String?
    var unit:String?
    var image:String?
    var size:String?
    var price:String?
    var new_price:String?
    var rate:Double?
    var available:Int?
    var delivery_price:Double?
    var characteristics: [Properity]?
    var company: Company?
}

struct Properity: Decodable{
    var name:String?
    var value:String?
}
