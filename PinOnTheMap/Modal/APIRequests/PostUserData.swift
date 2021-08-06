//
//  GetUserDataResponse.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/4/21.
//

import Foundation
struct PostUserData : Encodable
 {
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL :String
    let latitude :Double
    let longitude: Double
 }
/*"{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)

*/
