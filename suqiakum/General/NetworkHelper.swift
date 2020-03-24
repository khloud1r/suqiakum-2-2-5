//
//  NetworkHelper.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation

class NetworkHelper{
    
    static var isLogIn: Bool?{
        didSet{
            UserDefaults.standard.set(isLogIn, forKey: "isLogIn")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getIsLogIn() -> Bool? {
        
        if let logIn = UserDefaults.standard.value(forKey: "isLogIn") as? Bool{
            NetworkHelper.isLogIn = logIn
        }
        return NetworkHelper.isLogIn
    }
    
    static var accessToken: String?{
        didSet{
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
        }
    }
    
    static var userEmail: String?{
        didSet{
            UserDefaults.standard.set(userEmail, forKey: "userEmail")
        }
    }
    
    static var userBalance: Double?{
        didSet{
            UserDefaults.standard.set(userBalance, forKey: "userBalance")
        }
    }
    
    static var userPoint: Double?{
        didSet{
            UserDefaults.standard.set(userPoint, forKey: "userPoint")
        }
    }
    
    static var userPhone: String?{
        didSet{
            UserDefaults.standard.set(userPhone, forKey: "userPhone")
        }
    }
    
    static var userImage: String?{
        didSet{
            UserDefaults.standard.set(userImage, forKey: "userImage")
        }
    }
    
    static var userName: String?{
        didSet{
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }
    
    static var address: String?{
         didSet{
             UserDefaults.standard.set(address, forKey: "address")
         }
     }
    
    static var userID: Int?{
        didSet{
            UserDefaults.standard.set(userID, forKey: "userID")
        }
    }
    
    static func getAccessToken() -> String? {
        if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String{
            NetworkHelper.accessToken = accessToken
            print("accessToken: \(accessToken)")
        }
        return NetworkHelper.accessToken
    }
    
    static func getUserEmail() -> String? {
        if let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String{
            NetworkHelper.userEmail = userEmail
            print("userEmail: \(userEmail)")
        }
        return NetworkHelper.userEmail
    }
    
    static func getUserPhone() -> String? {
        if let userPhone = UserDefaults.standard.value(forKey: "userPhone") as? String{
            NetworkHelper.userPhone = userPhone
            print("userPhone: \(userPhone)")
        }
        return NetworkHelper.userPhone
    }
    
    static func getUserPoints() -> Double? {
        if let userPoint = UserDefaults.standard.value(forKey: "userPoint") as? Double{
            NetworkHelper.userPoint = userPoint
            print("userPoint: \(userPoint)")
        }
        return NetworkHelper.userPoint
    }
    
    static func getUserBalance() -> Double? {
        if let userBalance = UserDefaults.standard.value(forKey: "userBalance") as? Double{
            NetworkHelper.userBalance = userBalance
            print("userBalance: \(userBalance)")
        }
        return NetworkHelper.userBalance
    }
    
    static func getuserImage() -> String? {
        if let userImage = UserDefaults.standard.value(forKey: "userImage") as? String{
            NetworkHelper.userImage = userImage
            print("userImage: \(userImage)")
        }
        return NetworkHelper.userImage
    }
    
    static func getUserName() -> String? {
        if let userName = UserDefaults.standard.value(forKey: "userName") as? String{
            NetworkHelper.userName = userName
            print("userName: \(userName)")
        }
        return NetworkHelper.userName
    }
    
    static func getAddress() -> String? {
         if let address = UserDefaults.standard.value(forKey: "address") as? String{
             NetworkHelper.address = address
             print("address: \(address)")
         }
         return NetworkHelper.address
     }
    
    static func getUserId() -> Int? {
        if let userID = UserDefaults.standard.value(forKey: "userID") as? Int{
            NetworkHelper.userID = userID
            print("userID: \(userID)")
        }
        return NetworkHelper.userID
    }
    
    static func logoutAccessTokenCleanUp() {
        NetworkHelper.accessToken = nil
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
    
    static func logoutUserEmailCleanUp() {
        NetworkHelper.userEmail = nil
        UserDefaults.standard.removeObject(forKey: "userEmail")
    }
    
    static func logoutUserPointsCleanUp() {
        NetworkHelper.userPoint = nil
        UserDefaults.standard.removeObject(forKey: "userPoint")
    }
    
    static func logoutUserBalanceCleanUp() {
        NetworkHelper.userBalance = nil
        UserDefaults.standard.removeObject(forKey: "userBalance")
    }
    
    static func logoutUserPhoneCleanUp() {
        NetworkHelper.userPhone = nil
        UserDefaults.standard.removeObject(forKey: "userPhone")
    }
    
    static func logoutUserImageCleanUp() {
        NetworkHelper.userImage = nil
        UserDefaults.standard.removeObject(forKey: "userImage")
    }
    
    static func logoutUserNameCleanUp() {
        NetworkHelper.userName = nil
        UserDefaults.standard.removeObject(forKey: "userName")
    }
    
    static func logoutUserIdCleanUp() {
        NetworkHelper.userID = nil
        UserDefaults.standard.removeObject(forKey: "userID")
    }
    
    static func logout() {
        NetworkHelper.isLogIn = nil
        UserDefaults.standard.removeObject(forKey: "isLogIn")
    }
    
}
