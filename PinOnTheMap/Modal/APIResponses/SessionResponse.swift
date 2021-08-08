//
//  SessionResponse.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/2/21.
//

import Foundation
struct SessionResponse : Codable
 {
    
    let session: SessionItems
    let account : AccountItems
    
 }

struct SessionItems : Codable
{
    let id : String
    let expiration : String
}

struct AccountItems : Codable{
    let registered : Bool
    let key : String
}


struct ErrorResponse:Decodable
{
    let status : Int
    let error : String
}

/*
{
    "account":{
        "registered":true,
        "key":"3903878747"
    },
    "session":{
        "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
        "expiration":"2015-05-10T16:48:30.760460Z"
    }
}
*/
