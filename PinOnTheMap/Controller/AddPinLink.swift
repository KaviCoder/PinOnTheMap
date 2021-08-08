//
//  ViewController.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/5/21.
//

import UIKit
import MapKit

class AddPinLink: UIViewController, UITextFieldDelegate,MKMapViewDelegate {
    
    @IBAction func cancel(_ sender: UIButton) {
        
        self.view.window?.rootViewController!.dismiss(animated: true)
    }
    
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    @IBOutlet weak var linkBox: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        linkBox.delegate = self
        waitIndicator.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField.text != ""
        {
            return true
        }
        textField.placeholder = "Please Enter the media URL"
     
        
        return true
    }

    @IBAction func submitted(_ sender: UIButton) {
        
     
        if linkBox.text != ""{
            waitIndicator.isHidden = false
            PinClient.PostPin.mediaURL = linkBox.text!
            //call Post Request
            
            PinClient.postUserData() { results in
             switch results
             {
             case.success(let data):
                print(data)
                
                PinClient.getLocationData(url : PinClient.EndPoints.getLatestRecord.url) { result in
                    DispatchQueue.main.async{
                        self.waitIndicator.isHidden = false
                        
                    }
                    switch result{
                    case .success(let res):
                        print(res)
                        DispatchQueue.main.async {
                            PinClient.mapData.append(contentsOf: res.results)
                            
//                            self.navigationController?.popToRootViewController(animated: true)
                            self.view.window?.rootViewController!.dismiss(animated: true)
                           
                        }

                    case .failure(let error):
                        print(error)
                        DispatchQueue.main.async {
                            self.showAlert(message: error.localizedDescription)
                        }


                    }
                }
                    
               
                
             case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.waitIndicator.isHidden = true
                    self.showAlert(message: error.localizedDescription)
                  
                }
                
             }
                
            }
            
        }
        else {
            DispatchQueue.main.async {
             
                self.showAlert(message:AlertsToTheError.ValidationError.LinkNotEntered.errorDescription )
              
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            
     
            
           // pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        waitIndicator.isHidden = false
        let centre = CLLocationCoordinate2D(latitude: CLLocationDegrees(PinClient.PostPin.latitude),longitude: CLLocationDegrees(PinClient.PostPin.longitude))
        let region = MKCoordinateRegion(center: centre , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
             self.mapView.setRegion(region, animated: true)
        
        
        //Create a pin at a coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = centre
        self.mapView.addAnnotation(annotation)
        waitIndicator.isHidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showAlert( message : String)
      {
          let myController = UIAlertController(title: "Please Enter Again", message: message, preferredStyle: .alert)
          myController.addAction(UIAlertAction(title: "OK", style: .default)
              
          )
          
          self.present(myController, animated: true, completion: nil)
      }

}
