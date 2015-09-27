//
//  WebServiceData.swift
//  Be-Happy
//
//  Created by ranjay on 9/13/15.
//  Copyright (c) 2015 Ranjay Salmon. All rights reserved.
//

import Foundation

struct WebServiceData {
    
    
    //var
    var results :[AnyObject];
    
    init(resultsArray: [AnyObject]){
        
        results = resultsArray;
        
        /*
        if let resultsData = resultsArray{
        
        results = resultsData;
        }else{
        results = nil;
        }
        */
        println(resultsArray[0])
        
        if let itemp = resultsArray[0] as? [String:AnyObject]{
        
            if let geo = itemp["geo"] as? [String: AnyObject]{
                
                if let test = geo["lat"] as? String{
                    println(test);
                }
            }
        }
    }
    
    func getPropertyFromData( objectId: String) -> [[String:Double]]{
        
        
        var tmpArray = [[String: Double]()];
        
        for item in self.results{
            
            
            
            
            if let itemValue = item[objectId] as? [String:Double]{
                
                tmpArray.append(itemValue);
                
                
                //println(item["content"] as! String);
            
                
                //tmpArray.append(itemValue);
                
            }
            
        }
        
        println(tmpArray);
        
        return tmpArray;
        
        
    };
    
    func getTweets(param: String) -> [String]{
        
        var tmpArray = [String]();
        
        for item in self.results{
            
            
            
            
            if let itemValue = item[param] as? String{
                
                tmpArray.append(itemValue);
                
                
                //println(item["content"] as! String);
                
                
                //tmpArray.append(itemValue);
                
            }
            
        }
        
        println(tmpArray);
        
        return tmpArray;
        

        
    };
    
    
}
