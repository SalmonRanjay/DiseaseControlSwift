//
//  ViewController.swift
//  DiseaseControl
//
//  Created by ranjay on 9/26/15.
//  Copyright (c) 2015 ranjay. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate, GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate {
    
    //var manager:CLLocationManager!;
    //var myLocations: [CLLocation] = [];
    
    
    var placeManager :GMBLPlaceManager!;
    var commManger :GMBLCommunicationManager!;
    
    var annotationsArray: [MKPointAnnotation] = [];
    
   
    
    let locationManager = CLLocationManager();
    var isGettingLocation = true;
    
    var myLocation = CLLocationCoordinate2D();

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        // Test sensor
        
        
        self.placeManager = GMBLPlaceManager();
        self.commManger = GMBLCommunicationManager();
        
        self.placeManager.delegate = self;
        commManger.delegate = self;
        
        
        // End sensor Test
        
        // Set up core location manager
       
        
        // Initializing core location
        
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.requestAlwaysAuthorization();
        
        self.locationManager.startUpdatingLocation();
       

        
        
        // 1
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        // 2
        
        //3
        
       
        
    }
    
    func placeManager(manager: GMBLPlaceManager!, didBeginVisit visit: GMBLVisit!) {
        println("Did begin Visit \(visit.place.name), at: \(visit.arrivalDate)" );
        let atts = visit.place.attributes as GMBLAttributes;
        let attKeys = atts.allKeys();
        
        for attKey in attKeys{
            
            println("\(attKey): \(atts.stringForKey(attKey as! String))");
        }
    }
    
    func placeManager(manager: GMBLPlaceManager!, didEndVisit visit: GMBLVisit!) {
        println("Did end visit: \(visit.place.name), at: \(visit.arrivalDate)");
    }
    
    func communicationManager(manager: GMBLCommunicationManager!, presentLocalNotificationsForCommunications communications: [AnyObject]!, forVisit visit: GMBLVisit!) -> [AnyObject]! {
        if(communications is [GMBLCommunication]){
            for comm in communications{
                
                println("comm Title: \(comm.title), description: \(comm.descriptionText)");
            }
        
        }
        return communications
    }
    
    // location manager delegate that updates the user's location
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            if(error != nil){
               // println("Error: " +,error.localizeDescription);
                return;
            }
            
            if(placemarks.count > 0 ){
                println(manager.location);
                
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm);
            }else{
                println("Error with data: ");
            }
        
        })
    };
    
    func displayLocationInfo(placemark: CLPlacemark){
        
      
        self.locationManager.stopUpdatingLocation();
         println("placemark:  \(placemark.location.coordinate.latitude)");
         println("placemark: long \(placemark.location.coordinate.longitude)");
        self.myLocation.longitude = placemark.location.coordinate.longitude;
        self.myLocation.latitude = placemark.location.coordinate.latitude;
       // self.isGettingLocation = false;
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.myLocation;//location
        annotation.title = "Big Ben";
        annotation.subtitle = "London";
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: self.myLocation, span: span)
        mapView.setRegion(region, animated: true)

        self.mapView.addAnnotation(annotation);
        
      
    };
    
    func displayNearByIllnesses(){
        
        if(annotationsArray.count > 0){
            self.mapView.removeAnnotations(annotationsArray)
        }
        
        var annotationObject = MKPointAnnotation();
        var locationObject = CLLocationCoordinate2D();
        // , -
        
        // , -
        
        // , -
        
        // , -
        var items: [[String:Double]] = [["lat":37.784765, "long":-122.407793], ["lat":37.785517, "long":-122.408988], ["lat":37.783575, "long":-122.409362], ["lat":37.784044, "long":-122.405022] ];
    
        
        for itemLocatin in items {
            if let lat = itemLocatin["lat"] {
                if let long = itemLocatin["long"] {
                    //let fullName = "\(firstName) \(lastName)"
                    locationObject.latitude = lat;
                    locationObject.longitude = long;
                    annotationObject.coordinate = locationObject;
                  
                    var obj:MKPointAnnotation  = MKPointAnnotation();
                    obj.coordinate = locationObject;
                    println(locationObject);
                      annotationsArray.append(obj);
                    
                   
                }
            }
        }
        
       // println(annotationsArray);
        
        
        self.mapView.addAnnotations(annotationsArray);
        
    };
    
    
    @IBAction func refreshIllnesses(sender: AnyObject) {
        
        self.displayNearByIllnesses();
    }
    
    
    @IBAction func updateUserLocation(sender: AnyObject) {
        
        self.locationManager.startUpdatingLocation()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

