//
//  Address.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation

struct AddressResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:[Address]?
}

struct AddressAddedResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:Address?
}

struct Address: Decodable{
    var id:Int?
//    var user_id:Int?
//    var city_id:Int?
    var name:String?
    var description:String?
    var longitude:String?
    var latitude:String?
    var is_default:Int?
}
