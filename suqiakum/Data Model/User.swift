//
//  User.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation

struct UserResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:User?
}

struct User: Decodable{
    var id:Int?
    var name:String?
    var email:String?
    var phone:String?
    var image:String?
//    var is_active:Bool?
//    var ios_token:String?
//    var activation_token:String?
    var total_points:Int?
    var total_balance:Int?
}
