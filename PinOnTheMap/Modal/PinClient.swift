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
    
    static var mapData : [ParseResult] = []
    {
        didSet{
            Logger.mapCount.info("\(mapData.count) locations are fetched")
        }
    }
    
    static func myDeleteRequest(id : String)
    {
        PinClient.deleteRequest(url: PinClient.EndPoints.deleteSession.url) { results in
            switch results{
            case .success(let data):
                print("******\(data)")
                HandleLogin.setDefaultMainWindowSetting(id: id,userName: "loggedOut" )
            case .failure(let error):
                print("error in logout")
                print(error)
            }
        }}
    
    struct PostPin
     {
        static var uniqueKey : String = ""
        static var firstName : String = ""
        static var lastName : String = ""
        static var mapString : String = ""
        static var mediaURL :String = ""
        static var latitude : Double = 0.0
        static var longitude: Double = 0.0
     }
    
    struct Auth {
       static var userID : String = ""
      
    }
    
    
    
 
    enum EndPoints{
        
        case postsession
        case getLocation
        case getLatestRecord
        case deleteSession
        case getUserData
        case postUserData
        
        var stringValue:String {
            switch self {
            case .getLocation : return  "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=10"
            case .getLatestRecord : return  "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=1"
            case .postsession: return "https://onthemap-api.udacity.com/v1/session"
            case .deleteSession : return "https://onthemap-api.udacity.com/v1/session"
            case .getUserData : return "https://onthemap-api.udacity.com/v1/users/" + "\(Auth.userID)"
            case .postUserData : return "https://onthemap-api.udacity.com/v1/StudentLocation"
                
            }
        }
        
        var url : URL{
            return URL(string: self.stringValue)!
        }
        
    }
    
    class func postUserData( completion: @escaping ((Result<String,Error>)-> Void) )
    {
        
        let body = PostUserData(uniqueKey: PostPin.uniqueKey, firstName: PostPin.firstName, lastName: PostPin.lastName, mapString: PostPin.mapString, mediaURL: PostPin.mediaURL, latitude: PostPin.latitude, longitude: PostPin.longitude)
        
        print(body)
        postRequest(url: EndPoints.postUserData.url, RequestBodyType: body, responseType: Data.self) { results in
            switch results
            {
            
              
            case .success(let res):
                
                print("success in \(#function) with \(res)")
//                let range = (5..<res.count)
//                let newData = res.subdata(in: range) /* subset response data! */
                print(String(data: res, encoding: .utf8)!)
                print(Auth.userID)
                completion(.success(String(data: res, encoding: .utf8)!))
                
               // let decorder = JSONDecoder()
                
//                do {
//                    let myResults = try decorder.decode(PostDataUserResp.self, from: res)
//                  print(myResults)
//
//                   completion(.success(myResults))
//                    return
//
//                }
//                catch{
//                    //if not decoded successfully
//                    print(error.localizedDescription)
//
//                    completion(.failure(error))
//                    }
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    class func getLocationData(url: URL = EndPoints.getLocation.url,completion :  @escaping (Result<ParseResponse,Error>)->Void){
        PinClient.getRequest(url: url, responseType: ParseResponse.self) { results in
            
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
            
        case .failure(let error):
            completion(.failure(error))
            
            
            case .success(let res):
                
                print("success in \(#function)...got some response")
                let range = (5..<res.count)
                let newData = res.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                
                
                //first tring to decode the result in erroredResponse then actual response
               
                
                let decorder = JSONDecoder()
                do {
                    let errorRes = try decorder.decode(ErrorResponse.self, from: newData)
                    let myError = myError(errorDescription: errorRes.error)
                    completion(.failure(myError))
                
                
                }
                catch{
                    //if we didn't got errr---Hurray!  We might got the data successfully
                   
                    do {
                        let myResults = try decorder.decode(SessionResponse.self, from: newData)
                        PinClient.Auth.userID = myResults.session.id
                     completion(.success(myResults))
                    
                    
                    }
                    catch{
                        //if not decoded successfully
                        print("******")
                        print(error.localizedDescription)
                        completion(.failure(error))
                       
                    }
                    
                   
                }
                
                
                
                
                
                
                
                
                
            }
        }
        
    }
       
    
    
    class func getUserData(completion :  @escaping (Result<UserDataResponse,Error>)->Void){
        PinClient.getRequest(url: PinClient.EndPoints.getUserData.url,responseType: Data.self) { results in
            
            switch results{
            
        
                
            case .success(let res):
                
                print("success in \(#function)")
                let range = (5..<res.count)
                let newData = res.subdata(in: range)
                /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                let decorder = JSONDecoder()
                
                do {
                    let myResults = try decorder.decode(UserDataResponse.self, from: newData)
                    print("Decoded Successfully")
                    return completion(.success(myResults))
                  
                }
                catch{
                    //if not decoded successfully
                    print(error.localizedDescription)
                    print(" not Decoded Successfully")
                    completion(.failure(error))
                }
                
              //  completion(.success(String(data: newData, encoding: .utf8)!))
            
            case .failure(let error):
                print(" no data Successfully")
                completion(.failure(error))
                
            }
        }
    }
    
//    class func DeleteRequest(completion: @escaping ((Result<Data,Error>)-> Void))
//    {
//        deleteRequest(url: PinClient.EndPoints.deleteSession.url) { results in
//            switch results{
//            case .success(let data):
//                print("Logout completed")
//                
//                DispatchQueue.main.async{
//                completion(.success(data))
//                }
//            case .failure(let error):
//                DispatchQueue.main.async{
//                completion(.failure(error))
//                }}
//        }
//    }
//    
    //Prime Methods Definitions
    
    class func getRequest<T : Decodable>(url : URL, responseType : T.Type = Data.self as! T.Type, completion: @escaping (Result<T, Error>)-> Void)
    {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard  data != nil else { print("there is no data")
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async {
                completion(.failure(error!))
                }
                return
            }
            
            if responseType == Data.self
            {       DispatchQueue.main.async {
                print(" returned successfully..data found in get data")
                completion(.success(data as! T))
            }}
            let decorder = JSONDecoder()
            
            do {
                let myResults  : T = try decorder.decode(T.self, from: data!)
                DispatchQueue.main.async {
               completion(.success(myResults))
                }
            }
            catch{
                //if not decoded successfully
                print(error.localizedDescription)
                DispatchQueue.main.async {
                completion(.failure(error))
                }}
            
            
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
            print(request.httpBody!)
       
           
        }
        catch {
            //  if not encoded successfully
            print(error.localizedDescription)
            print("failure in \(#function)")
            DispatchQueue.main.async {
            completion(.failure(error))
            }
            Logger.networkCall.error(" \(taskUUID, align: .right(columns: taskUUID.count)) with ending error : \(error.localizedDescription)")
            
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard  data != nil else { print("there is no data")
              
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async {
                completion(.failure(error!))
                }
                Logger.networkCall.error(" \(taskUUID, align: .right(columns: taskUUID.count)) with  no data : \(error!.localizedDescription)")
               
                return
                
            }
            guard error == nil else {
                Logger.networkCall.error(" \(taskUUID, align: .right(columns: taskUUID.count)) with error : \(error!.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
            completion(.success(data!))
            }
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
            if error != nil {
                DispatchQueue.main.async {
                  
                completion(.failure(error!))// Handle error…
                }
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async {
            completion(.success(newData!))
            }}
        task.resume()
    }
    
    
}
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    static let networkCall = Logger(subsystem: subsystem , category: "StringNetworkCalls")
    static let mapCount = Logger(subsystem: subsystem , category: "MapDataCount")
}


struct myError : LocalizedError
{
    
    var errorDescription: String?
    
    
}
