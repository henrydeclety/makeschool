//
//  HomeViewController.swift
//  myApp
//
//  Created by Henry on 7/18/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse
import youtube_ios_player_helper

class HomeViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    var nextUsers : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadNextUsers()
    }
    
    func reloadNextUsers() {
        User.findUsersQuery().findObjectsInBackgroundWithBlock({ (results : [PFObject]?, error : NSError?) in
            guard error == nil else {
                print("Error while fetching users")
                return
            }
            self.nextUsers = self.nextUsers + (results as? [User] ?? [])
            
            self.playerView.loadWithVideoId(self.nextUsers.first!.getPosts()?.first!["videoID"]! as! String)
            
        })
    }
    
}
