//
//  AlertsToTheError.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/7/21.
//

import Foundation
import UIKit

 struct  AlertsToTheError
 {

    
    enum ValidationError : LocalizedError
    {
        case NilValue
        case IncorrectLocation
        case LinkNotEntered
        
        var errorDescription: String{
        switch (self) {
        case .NilValue:
            return "Please Enter the text"
        case .IncorrectLocation:
            return "Couldn't locate this place. You can try nearby places"
            
        case .LinkNotEntered:
            return "Please enter the media link"
            
        }
        }
    }
 }
