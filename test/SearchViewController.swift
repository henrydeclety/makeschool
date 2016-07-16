//
//  ViewController.swift
//  test
//
//  Created by Henry on 7/13/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import youtube_ios_player_helper


class SearchViewController: UIViewController {
    
    var videosArray : [Dictionary<NSObject, AnyObject>] = []
    var selectedRow : Int?
    var start = 0
    var end = 15
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        searchField.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displaySelectedVideo" {
            let playerViewController = segue.destinationViewController as! PlayerViewController
            playerViewController.videoID = videosArray[tableView.indexPathForSelectedRow!.row]["videoID"] as! String
        }
    }
    
    
}

extension SearchViewController: UITextFieldDelegate {
    
    @IBAction func button(sender: UIButton) {
        textFieldShouldReturn(searchField)
    }
    
    // rajouter une view wait sijamais
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let targetURL = HTTPHelper.makeNSURLFromStringSearch(textField.text!)
        
        HTTPHelper.performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                do {
                    self.videosArray = []
                    // Convert the JSON data to a dictionary object.
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    // Get all search result items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // Loop through all search results and keep just the necessary data.
                    for i in 0 ..< items.count {
                        let snippetDict = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>
                        // Create a new dictionary to store the video details.
                        var videoDetailsDict = Dictionary<NSObject, AnyObject>()
                        videoDetailsDict["title"] = snippetDict["title"]
                        videoDetailsDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                        videoDetailsDict["videoID"] = (items[i]["id"] as! Dictionary<NSObject, AnyObject>)["videoId"]
                        
                        // Append the desiredPlaylistItemDataDict dictionary to the videos array.
                        self.videosArray.append(videoDetailsDict)
                        
                        // Reload the tableview.
                        self.tableView.reloadData()
                        
                    }
                } catch {
                    print("error with JSON")
                }
                
            } else {
                print("Error with http")
            }
        })
        return true
    }
}

extension SearchViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosArray.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
        let videoDetails = videosArray[indexPath.row]
        cell.title.text = videoDetails["title"] as? String
        cell.myImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: (videoDetails["thumbnail"] as? String)!)!)!)
        return cell
    }

}

extension SearchViewController : UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
    }


}