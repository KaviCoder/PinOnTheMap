//
//  ViewController.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/5/21.
//

import UIKit
import CoreLocation
import os

class AddPinLocation: UIViewController ,UITextFieldDelegate {

    @IBAction func cancel(_ sender: UIButton) {
    
        self.view.window?.rootViewController!.dismiss(animated: true)
        
    }
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addToTheMap: UIButton!
    @IBOutlet weak var locationText: UITextField!
    var coordinates   : CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        waitIndicator.isHidden = true
        locationText.delegate = self
        
        
       // call for userData is cmmented because the API is not giving correct result
        
                                PinClient.getUserData { results in
                                    switch results{
                                    case .success(let data):
                                        print("Already in success for User Data")
                                        print(data)
                                        PinClient.PostPin.firstName = data.first_name
                                        PinClient.PostPin.lastName = data.last_name
                                    
                                        return
                                        
                                    case .failure(let error):
                                      
                                        DispatchQueue.main.async{
                                            self.showAlert(message: error.localizedDescription)
                                        }
                                      
                                        
                                    }
                                }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let myText = textField.text
        print(myText as Any)
        textField.resignFirstResponder()
        if myText != "" {
            uiChanges(enable: true)
            getCoordinate(addressString: myText!) { [self] coordinate, error in
                
                self.uiChanges(enable: false)
                guard error == nil else {
                    print(error as Any)
                    textField.placeholder = "Please enter nearby places"
                    
                    DispatchQueue.main.async{
                        self.showAlert(message: AlertsToTheError.ValidationError.IncorrectLocation.errorDescription)
                    }
                    return
                }
              
                print(coordinate)
                //enable button
                self.coordinates = coordinate
                PinClient.PostPin.latitude = coordinate.latitude
                PinClient.PostPin.longitude = coordinate.longitude
                PinClient.PostPin.mapString = myText!
                PinClient.PostPin.uniqueKey = String(1234566666 + (arc4random() % 100))
                PinClient.PostPin.firstName = "KJ"
                PinClient.PostPin.lastName = "Jakson"
              
              
                
                
            }}
        else{
            textField.placeholder = "Please Enter the location"
        }
       return  true
    }
    
            
           
    
    
    @IBAction func addToMap(_ sender: UIButton) {
        //check if correct place is added or not
        //convert the locations into lat/long
        //
        
        if coordinates != nil && locationText.text != "" {
        performSegue(withIdentifier: "toLink", sender: self)
        }
        else {
            showAlert(message: AlertsToTheError.ValidationError.NilValue.errorDescription)
            
        }
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }

    func uiChanges(enable: Bool)
    {
        //if true...
        //disable the button-
        //wait indicator is not hidden...visible
            addToTheMap.isEnabled = !enable
        waitIndicator.isHidden = !enable
        
    }
   
    
    func showAlert( message : String)
      {
          let myController = UIAlertController(title: "Please Enter Again", message: message, preferredStyle: .alert)
          myController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
             
          }))
          
          self.present(myController, animated: true, completion: nil)
      }
    
    
   
}


