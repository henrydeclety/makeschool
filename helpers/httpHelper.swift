//
//  File.swift
//  myApp
//
//  Created by Henry on 7/13/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation

class HTTPHelper {
    
    static let type = "video"
    static let apiKey = "AIzaSyBLm073FUFI6DXiuiFWeMFV37y1Y9YqpHs"

    
    
    
    static func performGetRequest(targetURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: targetURL)
        request.HTTPMethod = "GET"
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
            })
        })
        
        task.resume()
    }
    
    static func makeNSURLFromStringSearch(text : String) -> NSURL {
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(text)&type=\(type)&key=\(apiKey)"
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return NSURL(string: urlString)!
    }

    
}