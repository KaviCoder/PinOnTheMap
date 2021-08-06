//
//  SessionReq.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/1/21.
//

import Foundation
struct LoginRequestModel: Codable {
    let udacity: AccountLoginRequestModel
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
struct AccountLoginRequestModel: Codable {
    let username: String
    let password: String
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}

//request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
