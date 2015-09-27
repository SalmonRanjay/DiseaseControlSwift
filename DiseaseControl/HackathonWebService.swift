//
//  BeHappyWebService.swift
//  Be-Happy
//
//  Created by ranjay on 9/12/15.
//  Copyright (c) 2015 Ranjay Salmon. All rights reserved.
//

import Foundation

class HackathonWebService{
    
    //let forecastAPIKey : String;
    let baseUrl: NSURL?;
    let endPoint: String;
    
    
    init (route: String){
        
        //self.forecastAPIKey = APIKey;
        baseUrl = NSURL(string: "http://hthon-test-app.mybluemix.net/");
        endPoint = route;
        
    }
    
    
    // method use to get forecast data
    
    func getData( completion: (WebServiceData? -> Void)){
        
        
        // appending extra fields to the url
        
        if let forecastURL = NSURL(string: endPoint, relativeToURL: baseUrl)?.absoluteURL{
            
            println("url:  \(forecastURL)");
            //http://localhost:9000/api/v1/content/getPosts
            
            // create instance of the network operation calss and initilaize it with the url needed
            let networkOperation = NetworkOperations(url: forecastURL);
            
            networkOperation.downloadJSONFromURL{
                (let JSONDictionary) in
                // do something
                
                let valueArray: AnyObject = (JSONDictionary?["tweets"] as? [AnyObject])!;
                
                //println(valueArray[0]);
                
                //println(JSONDictionary?["results"]);
                
                let results = self.currentDataFromJSON(JSONDictionary);
                
                completion(results);
            }
            
            
        }else{
            
            println("could not construct a valid url");
        }
        
        
        
    };
    
    
    
    
    
    
    func currentDataFromJSON(jsonDictionary: [String: AnyObject]?) ->WebServiceData?{
        
        // check that dictionary returns non nil value for result returned from API
        if let dataReturned: AnyObject = jsonDictionary?["tweets"] as? [AnyObject]{
            
            
            
            return WebServiceData(resultsArray: dataReturned as! [AnyObject]);
        }else{
            
            println("JSON dictionary returned nil for curcntly key");
            return nil;
        }
        
        
        
        
        
    };
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
