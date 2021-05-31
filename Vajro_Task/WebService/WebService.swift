//
//  WebService.swift
//  Vajro_Task
//
//  Created by Sethuram Vijayakumar on 26/05/21.
//

import Foundation
import SystemConfiguration
import UIKit


struct Resource<T>{
   
    var url : String
    var method : HTTPMethods
    var params : [String : Any]? = nil
    //    var parse : (Data) -> T?
}

enum isBaseApiURL {
    case yes
    case no
    case settingurl
}


enum HTTPMethods : String{
    case get     = "GET"
    case post    = "POST"
    case delete  = "DELETE"
    case put     = "PUT"
    case patch   = "PATCH"
    
}



public class Reachability {
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}

class WebService {
    public static var shared = WebService()
    private static var ContentType_HeaderKey = "Content-Type"
    private static var Authorization_HeaderKey = "Authorization"
    //    Resource<T>
    
    func loadData<T : Codable>(resource : Resource<T>, isLoaderNeed : YesNo = .no ,complition : @escaping (Swift.Result<T,ApiClientError> , _ statusCode : Int ) -> Void){
        let loader  : UIView = {
            return UIView()
        }()
        
        if Reachability().isConnectedToNetwork(){
            
            
            var urlString : String = resource.url
            if resource.method == .get{
                let getParam = resource.params ?? ["" : ""]
                urlString = urlString + "?" + getParam.queryString
            }
            guard let url : URL = URL(string: urlString) else {
                Log.er("URLError,\(urlString)")
                return}
            
            
            var request  = URLRequest(url:url)
            request.httpMethod = resource.method.rawValue
            if isLoaderNeed == .yes {
                loader.isHidden = false
            }
            
            guard let httpbody = try? JSONSerialization.data(withJSONObject: resource.params ?? ["" : ""], options: []) else {return}
            if resource.method != .get{
                request.httpBody = httpbody
            }
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.sync {
                    if isLoaderNeed == .yes {
                        loader.isHidden = true
                    }
                }
                if error != nil{
                    Log.er(url : urlString ,"\(resource.params ?? [:]) ")
                    complition(.failure(.apiConnection), 0)
                    return
                }
                guard let response = response as? HTTPURLResponse  else{
                    guard data != nil else { return }
                    
                    complition(.failure(.serverError), 0)
                    return
                }
                guard let data = data else {
                    complition(.failure(.noInternet), 0)
                    return
                }
                _ = String(data: data, encoding: .utf8)
                Log.rq(url : urlString ,"\(T.self)")
               
                guard let responseData = try? JSONDecoder().decode(T.self, from: data) else {
                    Log.er(url : urlString ,"Cont Decode, check you Model")
                    return
                }
                DispatchQueue.main.sync {
                    complition(.success(responseData), (response).statusCode)
                }
            }.resume()
        }else{
            showToast(msg: "Check your internet")
        }
    }
    
    
    
}




extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}


extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
}
