//
//  ViewController.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 7/29/21.
//

import UIKit
import os
class LoginViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Logger.viewCycle.info("View did load!")
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        
        if let userN  = userName.text ,let pass = password.text  {
        
  let sessReq = LoginRequestModel(udacity: AccountLoginRequestModel(username: userN, password: pass))
        
            PinClient.sessionRequest(body:sessReq.self) { results in
                switch results{
                case .success(let res):
                    print(res.session.id)
                 print("Success")
                    //call of data in maps
                    PinClient.getLocationData { result in
                        switch result{
                        case .success(let res):
                            print(res)
                            
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "toMaps", sender: self)
                            }

                        case .failure(let error):
                            print(error)


                        }
                    }
                   
                case .failure(let error):
                    print(error)
                    
                    
                }
            }
 
           
        
        
}}
      
    
    @IBAction func facebookLogin(_ sender: UIButton) {
    }
    
}

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    static let networkCall = Logger(subsystem: subsystem , category: "StringNetworkCalls")
}
