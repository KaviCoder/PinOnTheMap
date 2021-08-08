//
//  ViewController.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 7/29/21.
//

import UIKit
import os
class LoginViewController: KBUIViewController, UITextFieldDelegate {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var waitButton: UIActivityIndicatorView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInButton: OurCustomView!
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Logger.viewCycle.info("View did load!")
        userName.delegate = self
        password.delegate = self
        
        
    }
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
 // Wait till successfully logged in
        
        if let userN  = userName.text ,let pass = password.text  {
            updateUI(enable: true)
  let sessReq = LoginRequestModel(udacity: AccountLoginRequestModel(username: userN, password: pass))
        
            PinClient.sessionRequest(body:sessReq.self) { results in
                switch results{
                
                case .failure(let error):
                 
                    DispatchQueue.main.async{
                    self.updateUI(enable: false)
                        self.showAlert(message: error.localizedDescription)
                        return
                    }
                  
                    
                    
                
                case .success(let res):
                    print(res.session.id)
                 print("Success")
                    PinClient.getLocationData { result in
                        switch result{
                        case .success(let res):
                            print(res)
                            DispatchQueue.main.async {
                                PinClient.mapData = res.results
                                HandleLogin.setDefaultMainWindowSetting(id: HandleLogin.StoryBoardName.loggedIn.rawValue)
                                self.updateUI(enable: false)
                                    self.performSegue(withIdentifier: "toMaps", sender: self)
                                
                               
                            }

                        case .failure(let error):
                            print(error)
                            DispatchQueue.main.async
                                {
                                self.updateUI(enable: false)
                                self.showAlert(message: error.localizedDescription)
                              
                                }
                            }


                        }
                    }
                            
                           

                        
                }
              
            }
        else {
            //Show Alert
            showAlert(message: AlertsToTheError.ValidationError.NilValue.localizedDescription)
        }
           
        
        
}
      
    func updateUI(enable : Bool)
    {
       
        logInButton.isEnabled = !enable
        waitButton.isHidden = !enable
     
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
    }
    
    
    
  


    func showAlert( message : String)
      {
          let myController = UIAlertController(title: "Please Enter Again", message: message, preferredStyle: .alert)
          myController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              self.dismiss(animated: true, completion: nil)
          }))
          
          self.present(myController, animated: true, completion: nil)
      }
}

