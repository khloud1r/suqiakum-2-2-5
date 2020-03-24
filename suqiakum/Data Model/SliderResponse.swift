//
//  SliderResponse.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation

struct SliderResponse : Decodable {
    let status: Bool?
    let message: String?
    let data: [Slider]?
}

struct Slider : Decodable {
    let id: Int?
    let image: String?
    let action_type: String?
    let type_id: Int?
    let is_active: Int?
    let object: Company?
}
