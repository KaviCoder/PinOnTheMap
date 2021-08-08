//
//  HandleLogin.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/6/21.
//

import Foundation
import UIKit


struct HandleLogin {
    
    enum StoryBoardName : String
    {
        case loggedIn = "TabBarController"
        case loggedOut = "LoginViewController"
    }
    
    static  func setDefaultMainWindowSetting(id :String, userName : String = "LoggedIn")
    { print(id)
        //if logged in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       
           
        let mainTabBar = storyboard.instantiateViewController(identifier: id)
        (UIApplication.shared.connectedScenes.first?.delegate as?  SceneDelegate)?.changeRootViewController(mainTabBar)
        let defaults = UserDefaults.standard
        
        if id == StoryBoardName.loggedIn.rawValue
        {
            let auth = PinClient.Auth.userID
            print("saved, login")
            defaults.set(true, forKey: "UserLoggedIn")
            defaults.set(PinClient.Auth.userID, forKey: "AuthID")
            
        }
        else
        {   print("removed, logout")
            defaults.set(false, forKey: "UserLoggedIn")
            defaults.set("", forKey: "AuthID")
            
        }
    
}
    
    
    

}
