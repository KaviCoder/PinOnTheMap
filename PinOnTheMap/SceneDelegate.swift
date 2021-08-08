//
//  SceneDelegate.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 7/29/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

   
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        print("Sene Delegate")
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.standard.bool(forKey: "UserLoggedIn") != false && (UserDefaults.standard.string(forKey: "AuthID") != "")
        {
            
       
            let mainTabBar = storyboard.instantiateViewController(identifier: "TabBarController")
            window?.rootViewController = mainTabBar
           PinClient.Auth.userID = UserDefaults.standard.string(forKey: "AuthID")!
            print("Already loggedIn")
        }
        else{
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginViewController")
            window?.rootViewController = loginNavController
        }
        
        
       //Get the data on our array
           
            
        }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    
    

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func changeRootViewController(_ vc:UIViewController, animated: Bool = true){
        guard let window = self.window else{
            return
        }
        DispatchQueue.main.async {
           
        window.rootViewController = vc
        
        //Adding transition
        UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
        }
    }

}

