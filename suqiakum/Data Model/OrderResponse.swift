//
//  OrderResponse.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/17/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation

struct OrdersResponse: Decodable {
    var status:Bool?
    var message:String?
    var data: OrdersData?
}

struct OrdersData: Decodable {
    var current_page: Int?
    var last_page: Int?
    var data: [Order]?
}

struct OrderResponse: Decodable {
    var status:Bool?
    var message:String?
    var data:Order?
}

struct Order: Decodable {
    var id:Int?
    var slug:String?
    var address:Address?
    var price:String?
    var vat:String?
    var delivery_price:String?
    var discount:String?
    var total_price:String?
    var quantity:Int?
    var payment_method:String?
    var recipient_name:String?
    var recipient_phone:String?
    var delivery_date:String?
    var delivery_time:String?
    var status:String?
    var created_at:String?
    var company:Company?
    var products:[Product]?
    var statuses:[Status]?
}

struct Product: Decodable {
    var id:Int?
    var slug:String?
    var company_id:Int?
    var name:String?
    var description:String?
    var image:String?
    var size:String?
    var price:String?
    var rate:Double?
    var quantity:Int?
}

struct Status: Decodable {
    var id:Int?
    var order_id:Int?
    var status:String?
    var is_active:Int?
}
