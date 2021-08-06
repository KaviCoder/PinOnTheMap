//
//  ViewController.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 8/5/21.
//

import UIKit
import MapKit

class AddPinLink: UIViewController, UITextFieldDelegate,MKMapViewDelegate {

    @IBOutlet weak var linkBox: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        linkBox.delegate = self

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
            PinClient.PostPin.mediaURL = linkBox.text!
            //call Post Request
            
            PinClient.postUserData() { results in
             switch results
             {
             case.success(let data):
                print(data)
                self.navigationController?.popToRootViewController(animated: true)
                
             case .failure(let error):
                print(error)
                
             }
                
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
        let centre = CLLocationCoordinate2D(latitude: CLLocationDegrees(PinClient.PostPin.latitude),longitude: CLLocationDegrees(PinClient.PostPin.longitude))
        let region = MKCoordinateRegion(center: centre , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
             self.mapView.setRegion(region, animated: true)
        
        
        //Create a pin at a coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = centre
        self.mapView.addAnnotation(annotation)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
