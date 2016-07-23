//
//  SettingsViewController.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addExtract(sender: AnyObject) {
        
        if (PFUser.currentUser() as! User).isSpotifyUser() {
            let alertController = UIAlertController(title: "Titre", message: "Where do you want to get your extract from?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let youtubeSearch = UIAlertAction(title: "Youtube", style: .Default) { (action) in
                self.performSegueWithIdentifier("YTSearch", sender: self)
            }
            alertController.addAction(youtubeSearch)
            
            let spotifySearch = UIAlertAction(title: "Spotify", style: .Default) { (action) in
                self.performSegueWithIdentifier("SpotiSearch", sender: self)
            }
            alertController.addAction(spotifySearch)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("YTSearch", sender: self)
        }
    }
}
