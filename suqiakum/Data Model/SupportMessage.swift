//
//  SupportMessage.swift
//  suqiakum
//
//  Created by HadyHammad on 3/13/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation

struct SupportMessageResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:SupportMessage?
}

struct SupportMessage: Decodable{
    var id:Int?
    var user_id:Int?
    var name:String?
    var phone:String?
    var title:String?
    var message:String?
}
