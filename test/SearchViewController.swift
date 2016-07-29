//
//  ViewController.swift
//  test
//
//  Created by Henry on 7/13/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import youtube_ios_player_helper


public class SearchViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var tracksArray : [Dictionary<NSObject, AnyObject>] = []
    var timeLeft : Int!
    var selectedRow : Int?
    var start = 0
    var end = 15
    var isYoutube : Bool!
    var handle : ((SearchViewController, String) -> Void)?
    var isHandling = false

    override public func viewDidLoad() {
        handle = isYoutube! ? HTTPHelper.handleYTSearch : HTTPHelper.handleSPTSearch
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Enter a song"
        navigationBar.title = isYoutube! ? "Youtube" : "Spotify"
        view.backgroundColor = isYoutube! ? UIColor.darkGrayColor() : UIColor.whiteColor()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! SelectViewController
        let details = tracksArray[tableView.indexPathForSelectedRow!.row]
        dest.maxTimeInterval = timeLeft
        if segue.identifier == "YTSelect" {
            dest.post = Post(title: details["title"] as! String, videoID: details["videoID"] as! String, thumbnail: details["thumbnail"] as! String)
        } else if segue.identifier == "SPTSelect" {
            dest.post = Post(name: details["name"] as! String, artist: details["artist"] as! String, playableURI: details["playableURI"] as! NSURL, duration: details["duration"] as! Int)
        }
    }
    
    @IBAction public func stopPlaying(segue: UIStoryboardSegue) {
        if !isYoutube! {
            SpotifyHelper.stop()
        }
    }
    
}

extension SearchViewController : UITableViewDataSource{
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracksArray.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if isYoutube! {
            let cell = tableView.dequeueReusableCellWithIdentifier("Youtube") as! YoutubeVideoCell
            return cell.fill(trackDetails: tracksArray[indexPath.row])
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Spotify") as! SpotifyTrackCell
            return cell.fill(trackDetails: tracksArray[indexPath.row])
        }
    }
    
}

extension SearchViewController : UITableViewDelegate {

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if (!isHandling){
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.selected = false
        }
    }
}

extension SearchViewController : UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dissmisKeyboard()
        handle!(self, searchBar.text!)
    }
    
    public func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
        searchBarSearchButtonClicked(searchBar)
    }
    
    public func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("begin")
    }
    
    public func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("end")
    }
        
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        isHandling = true
        handle!(self, searchBar.text!)
        isHandling = false
    }
    
    func dissmisKeyboard() {
        view.endEditing(true)
    }

}