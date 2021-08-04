//
//  ParseResponse.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/1/21.
//

import Foundation

struct ParseResponse : Decodable
{
    let results : [ParseResult]

   
}
 
struct ParseResult : Decodable
{
    let objectId : String
    let uniqueKey : String
    let firstName : String
    let  lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Float
    let longitude : Float
}
