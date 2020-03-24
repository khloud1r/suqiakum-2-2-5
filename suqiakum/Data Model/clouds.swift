//
//  clouds.swift
//  suqiakum
//
//  Created by hany karam on 3/2/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import Foundation
struct Clouds : Codable {
    let all : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case all = "all"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(Int.self, forKey: .all)
    }
    
}
