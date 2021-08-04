//
//  File.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 7/29/21.
//

import UIKit
import os

class PinClient
{
    static var networkUUID : String{
        return "\(UUID())"
    }
    
    struct Auth {
       static var userID : Int = 0
    }
    
    enum EndPoints{
        
        case postsession
        case getLocation
        case deleteSession
        case getUserData
        
        var stringValue:String {
            switch self {
            case .getLocation : return  "https://onthemap-api.udacity.com/v1/StudentLocation?limit=10"
            case .postsession: return "https://onthemap-api.udacity.com/v1/session"
            case .deleteSession : return "https://onthemap-api.udacity.com/v1/session"
            case .getUserData : return "https://onthemap-api.udacity.com/v1/users/" + "\(Auth.userID)"
                
            }
        }
        
        var url : URL{
            return URL(string: self.stringValue)!
        }
        
    }
    
    class func getLocationData(completion :  @escaping (Result<ParseResponse,Error>)->Void){
        PinClient.getRequest(url: EndPoints.getLocation.url, responseType: ParseResponse.self) { results in
            
            switch results{
            case .success(let res):
                completion(.success(res))
                
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        
    }
    
    class func sessionRequest(body: LoginRequestModel,completion :  @escaping (Result<SessionResponse,Error>)->Void){
        PinClient.postRequest(url: PinClient.EndPoints.postsession.url, RequestBodyType: body, responseType: SessionResponse.self) { results in
            
            switch results{
            case .success(let res):
                
                print("success in \(#function)")
                let range = (5..<res.count)
                let newData = res.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                let decorder = JSONDecoder()
                
                do {
                    let myResults = try decorder.decode(SessionResponse.self, from: newData)
                    return completion(.success(myResults))
                    
                }
                catch{
                    //if not decoded successfully
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
                
                
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        
    }
       
    
    
    class func getUserData(body: LoginRequestModel,completion :  @escaping (Result<SessionResponse,Error>)->Void){
        PinClient.postRequest(url: PinClient.EndPoints.postsession.url, RequestBodyType: body, responseType: SessionResponse.self) { results in
            
            switch results{
            case .success(let res):
                
                print("success in \(#function)")
                let range = (5..<res.count)
                let newData = res.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                let decorder = JSONDecoder()
                
                do {
                    let myResults = try decorder.decode(SessionResponse.self, from: newData)
                    return completion(.success(myResults))
                    
                }
                catch{
                    //if not decoded successfully
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
                
                
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        
    }
    class func DeleteRequest(completion: @escaping ((Result<Data,Error>)-> Void))
    {
        deleteRequest(url: PinClient.EndPoints.deleteSession.url) { results in
            switch results{
            case .success(let data):
                print("Logout completed")
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //Prime Methods Definitions
    
  class func getRequest<T : Decodable>(url : URL, responseType : T.Type, completion: @escaping (Result<T, Error>)-> Void)
    {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard  data != nil else { print("there is no data")
                print(error?.localizedDescription as Any)
                completion(.failure(error!))
                return
                
                                       }
            let decorder = JSONDecoder()
            
            do {
                let myResults  : T = try decorder.decode(T.self, from: data!)
                return completion(.success(myResults))
                
            }
            catch{
                //if not decoded successfully
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            
        }
        task.resume()
        
        //POST
    }
    class func postRequest< RequestType: Encodable,ResponseType: Decodable>(url : URL,RequestBodyType: RequestType , responseType : ResponseType.Type, completion: @escaping (Result<Data, Error>)-> Void)
    { let taskUUID = networkUUID
        
        Logger.networkCall.info("URL:\(url) called with \(taskUUID, align: .right(columns: taskUUID.count))")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encoding a JSON body from a string, can also use a Codable struct
        
        
        let encoder =  JSONEncoder()
        
        do {
            let res =  try encoder.encode(RequestBodyType)
            request.httpBody = res
            print("success in \(#function)")
           
        }
        catch {
            //  if not encoded successfully
            print(error.localizedDescription)
            print("failure in \(#function)")
            completion(.failure(error))
            Logger.networkCall.error(" \(taskUUID, align: .right(columns: taskUUID.count)) with ending error : \(error.localizedDescription)")
            
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard  data != nil else { print("there is no data")
              
                print(error?.localizedDescription as Any)
                completion(.failure(error!))
                Logger.networkCall.error(" \(taskUUID, align: .right(columns: taskUUID.count)) with  no data : \(error!.localizedDescription)")
               
                return
                
            }
            guard error == nil else {
                Logger.networkCall.error(" \(taskUUID, align: .right(columns: taskUUID.count)) with error : \(error!.localizedDescription)")
                return
            }
            completion(.success(data!))
            Logger.networkCall.info(" \(taskUUID, align: .right(columns: taskUUID.count)) with data : \(data!.count)")
            return
            //            let decorder = JSONDecoder()
            //
            //            do {
            //          let myResults = try decorder.decode(ResponseType.self, from: data!)
            //                return completion(.success(myResults.self as! Data))
            //
            //            }
            //            catch{
            //                //if not decoded successfully
            //                print(error.localizedDescription)
            //                print("failure in \(#function)")
            //                completion(.failure(error))
            //            }
            //
            
        }
        task.resume()
        
    }
    
    
    //Delete Session
    class func deleteRequest(url : URL, completion: @escaping (Result<Data, Error>)-> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
}
