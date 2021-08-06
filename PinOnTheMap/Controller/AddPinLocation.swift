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

    @IBOutlet weak var locationText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationText.delegate = self
       // call for userData
                                PinClient.getUserData { results in
                                    switch results{
                                    case .failure(let error):
                                        Logger.networkCall.error("Error occured while calling \(#function) from \(#file) with error : \(error.localizedDescription)")
                                    case .success(let data):
                                        print("Already in success for User Data")
                                        print(data)
//                                        PinClient.PostPin.firstName = data.first_name
//                                        PinClient.PostPin.lastName = data.last_name
                                        PinClient.PostPin.firstName = "k"
                                        PinClient.PostPin.lastName = "J"
                                        
                                    }
                                }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let myText = textField.text
        print(myText)
        textField.resignFirstResponder()
        if myText != "" {
            getCoordinate(addressString: myText!) { coordinate, error in
                guard error == nil else {
                    print(error as Any)
                    textField.placeholder = "Please enter nearby places"
                    return
                }
                
                print(coordinate)
                
                
            }}
       return  true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let myText = textField.text!
            
        if myText != ""{
            getCoordinate(addressString: myText) { coordinate, error in
                guard error == nil else {
                    print(error as Any)
                    textField.placeholder = "Please enter nearby places"
                    return
                }
                
                print(coordinate)
                PinClient.PostPin.latitude = coordinate.latitude
                PinClient.PostPin.longitude = coordinate.longitude
                PinClient.PostPin.mapString = myText
                PinClient.PostPin.uniqueKey = String(1234566666 + (arc4random() % 100))
                
                
            }}}
            
            
           
    
    
    @IBAction func addToMap(_ sender: UIButton) {
        //check if correct place is added or not
        //convert the locations into lat/long
        //
        performSegue(withIdentifier: "toLink", sender: self)
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

}

