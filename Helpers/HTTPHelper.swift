//
//  File.swift
//  myApp
//
//  Created by Henry on 7/13/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation

public class HTTPHelper {
    
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
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(text)&type=\(type)&key=\(apiKey)"
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return NSURL(string: urlString)!
    }
    
    public static func handle(sender : SearchViewController, text : String) {
        if !text.isEmpty {
            if sender.isYoutube! {
                handleYTSearch(sender, text: text)
            } else {
                handleSPTSearch(sender, text: text)
            }
        }
    }
    
    public static func handleSPTSearch(sender : SearchViewController, text : String) {
        sender.tracksArray = []
        SPTSearch.performSearchWithQuery(text, queryType: SPTSearchQueryType.QueryTypeTrack, accessToken: SPTAuth.defaultInstance().session.accessToken) { (error, result) in
            guard error == nil else {
                ErrorHandling.defaultErrorHandler(error)
                return
            }
            if let list = (result as? SPTListPage)?.items {
                for item in list {
                    var trackDetailsDict = Dictionary<NSObject, AnyObject>()
                    let track = item as! SPTPartialTrack
                    trackDetailsDict["name"] = track.name
                    trackDetailsDict["artist"] = (track.artists[0] as? SPTPartialArtist)!.name
                    trackDetailsDict["playableURI"] = track.playableUri
                    trackDetailsDict["duration"] = track.duration
                    sender.tracksArray.append(trackDetailsDict)
                }
                sender.tableView.reloadData()
            }
        }
    }
    
    
    public static func handleYTSearch(sender : SearchViewController,  text : String){
        let targetURL = HTTPHelper.makeNSURLFromStringSearch(text)
        
        HTTPHelper.performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                do {
                    sender.tracksArray = []
                    // Convert the JSON data to a dictionary object.
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    // Get all search result items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // Loop through all search results and keep just the necessary data.
                    for i in 0 ..< items.count {
                        let snippetDict = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>
                        // Create a new dictionary to store the video details.
                        var trackDetailsDict = Dictionary<NSObject, AnyObject>()
                        trackDetailsDict["title"] = snippetDict["title"]
                        trackDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                        trackDetailsDict["videoID"] = (items[i]["id"] as! Dictionary<NSObject, AnyObject>)["videoId"]
                        
                        // Append the desiredPlaylistItemDataDict dictionary to the videos array.
                        sender.tracksArray.append(trackDetailsDict)
                        
                        // Reload the tableview.
                    }
                    sender.tableView.reloadData()
                } catch {
                    print("error with JSON")
                }
                
            } else {
                print("Error with http")
            }
        })
    }

    
}