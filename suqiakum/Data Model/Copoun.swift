//
//  Copoun.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/10/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
struct CopounResponse: Decodable{
    var status:Bool?
    var message:String?
    var data:Copoun?
}

struct Copoun: Decodable{
    var id:Int?
    var copoun_code:String?
    var amount:Int?
    var max_amount:Int?
    var expired:Int?
    var max_uses:Int?
}
