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
    
  
}
