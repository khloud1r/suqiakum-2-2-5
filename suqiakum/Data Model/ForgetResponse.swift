//
//  ForgetResponse.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/20/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
struct ForgertResponse : Decodable {
    let status: Bool?
    let message: String?
    let data: ForgertDataClass?
}

struct ForgertDataClass: Decodable {
    let phone: String?
    let token: String?
    let id: Int?
}

struct CheckToken : Decodable {
    let status:Bool?
    let message:String?
    let access_token:String?
}

struct Reset: Decodable {
    let status: Bool?
    let message, tokenType, expiresIn, accessToken: String?
    let data: User?
}
