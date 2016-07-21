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

public class HomeViewController: UIViewController {

    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    var nextUsers : [User] = []
    var currentPosts : [Post] = []
    var currentUser : User?
    private var firstRound = true
    
    //cte
    let ended = 1
    let thresholdToReloadUsers = 2
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        reloadNextUsers()
    }
    
    
    @IBAction func nextUser(sender: AnyObject) {
        Like.addLike(from: PFUser.currentUser() as! User, to: currentUser!, bool: false)
        consumeUser()
    }
    
    @IBAction func like(sender: AnyObject) {
        Like.addLike(from: PFUser.currentUser() as! User, to: currentUser!, bool: true)
        consumeUser()
    }
    
    func nextPost(sender: AnyObject) {
        if (!currentPosts.isEmpty){
            playPost(currentPosts.removeFirst(), first: false)
        } else {
            print("done")
        }
    }
    
    func reloadNextUsers() {
        User.findUsersQuery().findObjectsInBackgroundWithBlock({ (results : [PFObject]?, error : NSError?) in
            guard error == nil else {
                print("Error while fetching users")
                return
            }
            self.nextUsers = self.nextUsers + (results as? [User] ?? [])
            
            //Consume first user
            if(self.firstRound){
                self.firstRound = false
                self.consumeUser()
            }
        })
    }
    
    func consumeUser(){
        if(nextUsers.count < thresholdToReloadUsers){
            reloadNextUsers()
        }
        currentUser = nextUsers.removeFirst()
        currentUser!.getPosts(self)
    }
    
    public func display(user : User){
        currentPosts = user.posts!
        
        //feeling in display info
        descriptionView.text = user["description"] as? String ?? ""
        
        age.text = String(user["age"] as! Int)
        sex.text = user["sex"] as! Bool ? "Man" :  "Woman"
        
        playPost(currentPosts.removeFirst(), first: true)
        
    }
    
    public func playPost(post : Post, first : Bool){
        let dico = NSMutableDictionary()
        dico.setObject(0, forKey: "autohide")
        dico.setObject(1, forKey: "playsinline")
        dico.setObject(0, forKey: "rel")
        dico.setObject("http://www.youtube.com", forKey: "origin")
        dico.setObject(post["start"]! as! Float, forKey: "start")
        dico.setObject(post["end"]! as! Float, forKey: "end")
        if (first){
            playerView.loadWithVideoId(post["videoID"] as! String, playerVars: dico as [NSObject : AnyObject])
        } else {
            playerView.cueVideoById(post["videoID"] as! String, startSeconds: post["start"]! as! Float, endSeconds: post["end"]! as! Float, suggestedQuality: YTPlaybackQuality.Auto)
        }
    }
    
}

extension HomeViewController : YTPlayerViewDelegate {

    public func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState) {
        if (state.rawValue == ended){
            nextPost(self)
        } else if (state.rawValue == 5){
            playerView.playVideo()
        }
    }

}

