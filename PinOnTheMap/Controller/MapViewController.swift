//
//  MapViewController.swift
//  PinOnTheMap
//
//  Created by Kavya Joshi on 7/29/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
 
    @IBOutlet weak var mapView: MKMapView!

   
     var pinButton : UIBarButtonItem!
    var logOutButton : UIBarButtonItem!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationButtons()
        mapView.delegate = self
        self.fetchData(){ result in
            print(result)
            self.addAnnotation()
        }
      
        if UserDefaults.standard.bool(forKey: "UserLoggedIn"){
            
            print("I am loggedIn")}
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:])
                //app.openURL(URL(string: toOpen)!)
               
            }
        }
    }
    
 
    


     
    
    func fetchData(completion : @escaping (Bool)->()){
    
  
        PinClient.getLocationData { result in
            switch result{
            case .success(let res):
                print(res)
                    PinClient.mapData = res.results
                completion(true)
                
            case .failure(let error):
                print(error)
                completion(false)


            }}}
    
    
    
    func addAnnotation() {
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()

        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.

        for dictionary in PinClient.mapData {
           
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude )
            let long = CLLocationDegrees(dictionary.longitude)
            
          //  print(lat,long)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
           // print(coordinate)
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
            
        }
    //MARK:- Navigation Items
    func  addNavigationButtons()
    {
      
        pinButton = UIBarButtonItem(image: UIImage(named: "icon_pin"), style: .done, target: self, action: #selector(pinPressed(_:)))
    
        self.navigationItem.rightBarButtonItem = self.pinButton
        
        logOutButton = UIBarButtonItem( image : UIImage(named: "logout"), style: .done, target: self, action: #selector(logOutPressed(_:)))
        self.navigationItem.leftBarButtonItem = self.logOutButton
    }
    
   @objc func pinPressed(_ sender: UIBarButtonItem)  {
       
        performSegue(withIdentifier: "createPin", sender: self)
    }

   
    @objc func logOutPressed(_ sender: UIBarButtonItem) {
     
        PinClient.myDeleteRequest(id : HandleLogin.StoryBoardName.loggedOut.rawValue)
      
    }
    
}


//Centr Map to Location
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
