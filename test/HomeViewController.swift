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

    @IBOutlet weak var sptNext: UIButton!
    @IBOutlet weak var sptPlayPause: UIButton!
    @IBOutlet weak var waitingView: UIActivityIndicatorView!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    var nextUsers : [User] = []
    var currentPosts : [Post] = []
    var currentUser : User?
    private var firstRound = true
    var locationHelper = LocationManager()
    
    //cte
    let ended = 1
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        waitingView.hidden = false
        waitingView.startAnimating()
        playerView.delegate = self
        reloadNextUsers()
        locationHelper.test()
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
            currentPosts.removeFirst().playInHome(self, first: false)
        } else {
            print("done")
        }
    }
    
    func playPauseSPT(url : NSURL, start : Int, end : Int){
//        if sptPlayPause.currentImage.
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
        if(nextUsers.count < Constants.thresholdToReloadUsers){
            reloadNextUsers()
        }
        if nextUsers.isEmpty {
//
        } else {
            currentUser = nextUsers.removeFirst()
            currentUser!.displayPosts(display)
        }
    }
    
    public func display(user : User){
        currentPosts = user.posts!
        descriptionView.text = user["description"] as? String ?? ""
        age.text = String(user["age"] as! Int)
        sex.text = user["sex"] as! Bool ? "Man" :  "Woman"
        waitingView.hidden = true
        currentPosts.removeFirst().playInHome(self, first: true)
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

extension HomeViewController : CLLocationManagerDelegate {
    
}

