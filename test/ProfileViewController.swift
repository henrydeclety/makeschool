//
//  SettingsViewController.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse

public class ProfileViewController: UIViewController {
    
    @IBOutlet weak var completitionLabel: UILabel!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    let maxTimeAllowed = 900
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var time: UILabel!
    public var tracks : [Post] = [] {
        didSet {
            tableView.reloadData()
            updateTrackInfos()
        }
    }
    
    func updateTrackInfos() {
        var result : String = ""
        for track in tracks {
            result = result + (track.isYoutube() ? "1" : "0")
        }
        User.current()["hasContent"] = result != ""
        User.current()["trackInfos"] = result
        User.current().saveInBackground()
    }
    
    override public func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        reloadTracks()
    }
    
    @IBAction func editProfile(sender: AnyObject) {
    }
    
    
    func display(user : User){
        tracks = user.posts!
        time.text = "Time left : " + String(timeLeft()) + "s"
    }
    
    func timeLeft() -> Int {
        return maxTimeAllowed - tracks.map { (post) -> Int in post["duration"] as! Int }.reduce(0) { (a, b) -> Int in a+b }
    }
    
    func reloadTracks() {
        User.current().getPosts("profile", callback: display)
        updateLogin()
    }
    
    @IBAction func spotifyLogIn(sender: AnyObject) {
        SpotifyHelper().logIn(self)
    }
    
    @IBOutlet weak var labelWidthConstaint: NSLayoutConstraint!
    
    func updateLogin() {
        if SpotifyHelper.loggedIn() {
            loginLabel.text = "Logged in Spotify"
            loginButton.hidden = true
        } else {
            loginLabel.text = "Spotify premium user ?"
            loginButton.hidden = false
        }
    }
    
    @IBAction func addExtract(sender: AnyObject) {
        if (timeLeft() == 0){
            let alert = UIAlertController(title: nil, message: "You have no time left.", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Destructive, handler: nil)
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if SpotifyHelper.loggedIn() {
            let alertController = UIAlertController(title: nil, message: "Where do you want to get your extract from?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let youtubeSearch = UIAlertAction(title: "Youtube", style: .Default) { (action) in
                self.performSegueWithIdentifier("YTSearch", sender: self)
            }
            let spotifySearch = UIAlertAction(title: "Spotify", style: .Default) { (action) in
                self.performSegueWithIdentifier("SPTSearch", sender: self)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(youtubeSearch)
            alertController.addAction(spotifySearch)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("YTSearch", sender: self)
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! SearchViewController
        dest.isYoutube = segue.identifier == "YTSearch"
        dest.timeLeft = timeLeft()
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        tracks.append((segue.sourceViewController as! SelectViewController).post!)
    }
}

extension ProfileViewController : UITableViewDataSource {

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = tracks[indexPath.row]
        if post.isYoutube() {
            let cell = tableView.dequeueReusableCellWithIdentifier("Youtube") as! YoutubeVideoCell
            return cell.fill(post)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Spotify") as! SpotifyTrackCell
            return cell.fill(track: post)
        }
    }
    
}

extension ProfileViewController : UITableViewDelegate {
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tracks.removeAtIndex(indexPath.row).deleteInBackground()
        }
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath){
        
    }
    
}


