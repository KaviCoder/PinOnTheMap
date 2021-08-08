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
    
    static  func setDefaultMainWindowSetting(id :String, userName : String = "LoggedIn", completed : @escaping (Bool) -> Void)
    { print(id)
        //if logged in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       
           
        let mainTabBar = storyboard.instantiateViewController(identifier: id)
        (UIApplication.shared.connectedScenes.first?.delegate as?  SceneDelegate)?.changeRootViewController(mainTabBar)
        let defaults = UserDefaults.standard
        
        if id == StoryBoardName.loggedIn.rawValue
        {
           
            print("saved, login")
            defaults.set(true, forKey: "UserLoggedIn")
            defaults.set(PinClient.Auth.userID, forKey: "AuthID")
            completed(true)
            
        }
        else
        {   print("removed, logout")
            defaults.set(false, forKey: "UserLoggedIn")
            defaults.set("", forKey: "AuthID")
            completed(true)
            
        }
    
}
    
    
    

}
