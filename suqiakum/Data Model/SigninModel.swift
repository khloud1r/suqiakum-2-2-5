//
//  SigninModel.swift
//  suqiakum
//
//  Created by hany karam on 3/2/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

 import Foundation
struct SignInModel: Codable {
    let status: Bool?
    let message, tokenType, expiresIn, accessToken: String?
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case status, message
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int?
    let name, email: String?
    let phone: String?
    let image: String?
    let isActive: Int?
    let androidToken, iosToken, activationToken: String?
    let city: City?
    let totalPoints, totalBalance: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, image
        case isActive = "is_active"
        case androidToken = "android_token"
        case iosToken = "ios_token"
        case activationToken = "activation_token"
        case city
        case totalPoints = "total_points"
        case totalBalance = "total_balance"
    }
}
