//
//  TimeResponse.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/16/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
struct TimeResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:[Day]?
}

struct Day: Decodable{
    var id:Int?
    var day:String?
    var date:String?
    var times:[Time]?
}
struct Time: Decodable{
    var id:Int?
    var time:String?
}
