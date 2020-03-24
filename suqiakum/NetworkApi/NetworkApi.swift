 

import Foundation
import Alamofire
struct NetworkingManager {
    static let shared: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
}

class NetworkApi{
    //MARK;- Send Request
    /**
     This Function is used as an abstract to handle API requests using Alamofire
     - parameter method: The HTTP Methoud To Use
     - parameter url: is the url of service to call like login, register, getData in Type of String
     - parameter parameters: this is a Dictionary contains all data that you need to send this request
     - parameter header: is the authorization header attach with request
     - parameter closure: This is the final result that you can get data from request using it
     */
    class func sendRequest<T: Decodable>( userImage: Data? = nil, method: HTTPMethod, url: String, parameters:[String:Any]? = nil, header: [String:String]?  = nil, completion: @escaping (_ error: Error?, _ status: Bool?, _ response: T?)->Void) {
        NetworkingManager.shared.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .responseJSON { res -> Void in
                print(res.result.value)
                switch res.result
                {
                case .failure(let error):
                    completion(error,nil,nil)
                case .success(_):
                    if let dict = res.result.value as? Dictionary<String, Any>{
                        guard let status = dict["status"] as? Bool else{return}
                        do{
                            guard let data = res.data else { return }
                            let response = try JSONDecoder().decode(T.self, from: data)
                            completion(nil,status,response)
                        }catch let err{
                            print("Error In Decode Data \(err.localizedDescription)")
                            completion(err,false,nil)
                        }
                    }else{
                        completion(nil,false,nil)
                    }
                }
        }
        
    }
    
    class func getTotalPrice(copoun: String,completion: @escaping (_ error: Error?, _ status: Bool?, _ response: Dictionary<String, Double>?)->Void){
        NetworkingManager.shared.request(totalPrice, method: .post, parameters: ["copoun_code": copoun], encoding: URLEncoding.default, headers: authentication).responseJSON { res -> Void in
            print(res.result.value)
            switch res.result
            {
            case .failure(let error):
                completion(error,nil,nil)
            case .success(_):
                if let dict = res.result.value as? Dictionary<String, Any>{
                    guard let status = dict["status"] as? Bool else{return}
                    if status{
                        guard let data = dict["data"] as? Dictionary<String, Double> else{return}
                        completion(nil,true,data)
                    }else{
                        completion(nil,false,nil)
                    }
                }
            }
        }
    }
    
}
