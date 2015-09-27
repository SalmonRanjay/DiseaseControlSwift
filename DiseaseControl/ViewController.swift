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
    
    var locationArrays = [];
    var tweets = [];
    
    var combinedObject = [];
    
    var userAnnote = MKPointAnnotation();
    
    var userLat :String = "";
    var userLong:String = "";
    
    
    var placeManager :GMBLPlaceManager!;
    var commManger :GMBLCommunicationManager!;
    
    var annotationsArray: [MKPointAnnotation] = [];
    
   
    
    let locationManager = CLLocationManager();
    var isGettingLocation = true;
    
    var myLocation = CLLocationCoordinate2D();

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.352, green: 0.643, blue: 217/255.0, alpha: 1.0);
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
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
        //-77.022121/38.895139
        
        //3
        
        // Webservice test
        let beHappyService = HackathonWebService(route: "/api/location/search/-77.022121/38.895139");
        beHappyService.getData(){
            
            (let valueFromWeb) in
            
            if let webData = valueFromWeb {
                
                
                self.locationArrays = webData.getPropertyFromData("geo");
                println(self.locationArrays);
                // update UI
                // using grand central dispatch to return to the main thread
                // first parameter specifies the que we are using the main que hence "dispatch_get_main_quee
                self.tweets = webData.getTweets("text");
                
                
                
            
            }
            
        }
        
        // webservice test
        
       
        
    }
        
    func placeManager(manager: GMBLPlaceManager!, didBeginVisit visit: GMBLVisit!) {
        println("Did begin Visit \(visit.place.name), at: \(visit.arrivalDate)" );
        let atts = visit.place.attributes as GMBLAttributes;
        let attKeys = atts.allKeys();
        
        
        let alert = UIAlertController(title: "Warning", message: "Entering \(visit.place.name)", preferredStyle: UIAlertControllerStyle.Alert);
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil);


        
        for attKey in attKeys{
            
            println("\(attKey): \(atts.stringForKey(attKey as! String))");
        }
    }
    
    func placeManager(manager: GMBLPlaceManager!, didEndVisit visit: GMBLVisit!) {
        println("Did end visit: \(visit.place.name), at: \(visit.arrivalDate)");
        
        let alert = UIAlertController(title: "Warning", message: "leaving \(visit.place.name)", preferredStyle: UIAlertControllerStyle.Alert);
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil);

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
        self.userLat = placemark.location.coordinate.longitude.description//"\(placemark.location.coordinate.longitude)" ;
        self.userLong = placemark.location.coordinate.latitude.description//"\(placemark.location.coordinate.latitude)"
        
        self.userAnnote.coordinate = self.myLocation;
        self.userAnnote.title = "Im Sick";
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.myLocation;//location
        annotation.title = "Big Ben";
        annotation.subtitle = "London";
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: self.myLocation, span: span)
        mapView.setRegion(region, animated: true)

       // self.mapView.addAnnotation(self.userAnnote);
        
      
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
       // var items: [[String:Double]] = [["lat":37.784765, "long":-122.407793], ["lat":37.785517, "long":-122.408988], ["lat":37.783575, "long":-122.409362], ["lat":37.784044, "long":-122.405022] ];
    
        
        for itemLocatin in self.locationArrays {
            if let lat = itemLocatin["lat"] as? Double {
                if let long = itemLocatin["long"] as? Double {
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
        /*
        for(var i = 0; i < annotationsArray.count ; i++){
            
            annotationsArray[i].title = self.tweets[i] as! String;
            
        }
    */
        
        
        self.mapView.addAnnotations(annotationsArray);
        
    };
    
    
    
    
    @IBAction func refreshFeed(sender: AnyObject) {
        
        self.displayNearByIllnesses();
    }
    
    
    
    @IBAction func updateUserLocation(sender: AnyObject) {
        
        self.mapView.removeAnnotation(self.userAnnote)
        self.mapView.addAnnotation(self.userAnnote);
        self.locationManager.startUpdatingLocation()
        let networkOperation = NetworkOperations(url: NSURL(string: "http://hthon-test-app.mybluemix.net")!);
        networkOperation.postJSONFrom();
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

