//
//  Register.swift
//  suqiakum
//
//  Created by hany karam on 3/2/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

 import Foundation

struct RegisterModel : Codable {
      
    let status: Bool?
    let message: String?
    let data: RegisterDataClass?
}

    // MARK: - DataClass
    struct RegisterDataClass: Codable {
        let phone: String?
        let activation_token, id: Int?
        let image: String?
        let city: City?
        let total_points, total_balance: Int?
    }

    // MARK: - City
    struct City: Codable {
    }
