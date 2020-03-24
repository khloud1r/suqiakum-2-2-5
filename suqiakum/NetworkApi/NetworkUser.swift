//
//  Network.swift
//  suqiakum
//
//  Created by hany karam on 3/2/20.
//  Copyright © 2020 hany karam All rights reserved.
//

import Foundation
import Alamofire

class NetworkMangerUser {
    
    //static let jsonDecoder = JSONDecoder()
    static let instance = NetworkMangerUser()
    
    func registerNewUser (userInfoDict : [String:Any] , completion : @escaping( RegisterModel? , Error?) -> ()) {
        let headers = ["Content-Type" : "application/json"]
        Alamofire.request(register, method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(RegisterModel.self, from: response.data!)
                    print(responseModel)
                    completion(responseModel , nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    } // Register Function
    
    func loginUser (userInfoDict : [String:Any] , completion:@escaping ( SignInModel? ,  Error?) -> Void) {
        let headers = ["content-type" : "application/json"]
        
        Alamofire.request(login, method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result.value)
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(SignInModel.self, from: response.data!)
                    print( responseModel.accessToken)               
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    }
    
    func Activate (userInfoDict : [String:Any] , completion:@escaping ( ActivateModel? ,  Error?) -> Void) {
        let headers = ["content-type" : "application/json"]
        
        Alamofire.request(activite, method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(ActivateModel.self, from: response.data!)
                    print( responseModel)
                    
                    UserDefaults.standard.set(responseModel.access_token, forKey: "accessToken")
                    UserDefaults.standard.synchronize()
                    
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    }
    
    func ChechToken (userInfoDict : [String:Any] , completion:@escaping ( CheckToken? ,  Error?) -> Void) {
        let headers = ["content-type" : "application/json"]
        let url = "https://test.otc.net.sa/api/users/check_token"
        Alamofire.request(url, method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(CheckToken.self, from: response.data!)
                    print( responseModel)
                    
                    UserDefaults.standard.set(responseModel.access_token, forKey: "accessToken")
                    UserDefaults.standard.synchronize()
                    
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    }
    
    func Resend(userInfoDict : [String:Any] , completion:@escaping ( ActivateModel? ,  Error?) -> Void) {
        let headers = ["content-type" : "application/json"]
        
        print(userInfoDict)
        Alamofire.request(ResendActivation, method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(ActivateModel.self, from: response.data!)
                    print( responseModel)
                    
                    UserDefaults.standard.set(responseModel.access_token, forKey: "accessToken")
                    UserDefaults.standard.synchronize()
                    
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    }
    
    func Resetpassword (userInfoDict : [String:Any] , completion:@escaping ( Reset? ,  Error?) -> Void) {
        let headers = ["content-type" : "application/json"]
        let url = "https://test.otc.net.sa/api/users/reset_password"
        
        Alamofire.request(url, method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result.value)
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(Reset.self, from: response.data!)
                    print( responseModel.accessToken)
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    }
    
}

