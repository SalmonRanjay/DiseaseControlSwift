//
//  NetworkOperations.swift
//  Be-Happy
//
//  Created by ranjay on 9/12/15.
//  Copyright (c) 2015 Ranjay Salmon. All rights reserved.
//

import Foundation

class NetworkOperations{
    
    
    
    
    // TODO research lazy loadin
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration();
    lazy var session: NSURLSession = NSURLSession(configuration: self.config);
    
    let queryURL: NSURL;
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void;
    
    init(url: NSURL){
        
        self.queryURL = url;
    };
    
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion){
        
        // create an instance of nsurl request
        let request: NSURLRequest = NSURLRequest(URL : queryURL);
        
        let dataTask = session.dataTaskWithRequest(request){
            (let data, let response, let error) in
            
            // 1. check HTTP response for succesful GET request
            
            if let httpResponse = response as? NSHTTPURLResponse{
                
                switch(httpResponse.statusCode){
                    
                case 200, 202,201:
                    // 2. create a json object with data
                    
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject];
                    
                    // return the data using completion handler
                   // println(jsonDictionary);
                    
                    completion(jsonDictionary);
                    
                    break;
                default:
                    println("Get request not successful. HTTP status Code: \(httpResponse.statusCode)");
                    break;
                    
                }
                
            } else{
                
                println("Error not a valid http response ");
            }
            
            
            
            
        }
        
        dataTask.resume();
        
    }
    
    
    func postJSONFrom(){
        var request = NSMutableURLRequest(URL: NSURL(string: "http://hthon-test-app.mybluemix.net/api/twitter/sickTweet")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        //var params = ["username":"jameson", "password":"password"] as Dictionary<String, String>
        var params = [];
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
            }
    
  
}





