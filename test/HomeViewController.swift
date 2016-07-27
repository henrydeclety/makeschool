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

    
    @IBOutlet weak var sptPlayerView: SpotifyPlayerView!
    @IBOutlet weak var sptName: UILabel!
    @IBOutlet weak var sptArtist: UILabel!
    @IBOutlet weak var sptNext: UIButton!
    @IBOutlet weak var sptPlayPause: UIButton!
    @IBOutlet weak var waitingView: UIActivityIndicatorView!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    var waiting : Bool?
    var nextUsers : [User] = []
    var currentPosts : [Post] = []
    var currentPost : Post?
    var currentUser : User?
    private var firstRound = true
    var locationHelper = LocationManager()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        waitingView.hidden = false
        waitingView.startAnimating()
        ytPlayerView.delegate = self
        reloadNextUsers()
        locationHelper.test()
        SpotifyHelper.addObserver(self)
    }
    
    
    @IBAction func notLike(sender: AnyObject) {
        next(false)
    }
    
    @IBAction func like(sender: AnyObject) {
        next(true)
    }
    
    func next(bool : Bool){
        if let current = currentUser {
            Like.addLike(from: PFUser.currentUser() as! User, to: current, bool: bool)
            if consumeUser() == nil {
                noMoreUsers()
            }
        }
    }
    
    func noMoreUsers() {
        presentViewController(Constants.noMoreUsersAlert(), animated: true) { 
            self.consumeUser()
        }
    }
    
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>){
        guard SpotifyHelper.isSet() else {
            return
        }
        if keyPath == "currentPlaybackPosition" {
            let time = Int((object as! SPTAudioStreamingController).currentPlaybackPosition)
            if (time >= currentPost?.end!) {
                nextPost(self)
           } else if time < currentPost!.start {
                SpotifyHelper.player.seekToOffset(Double(currentPost!.start!), callback: nil)
           }
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
            if(self.currentUser == nil){
//                self.firstRound = false
                self.consumeUser()
            }
        })
    }
    
    func consumeUser() -> User? {
        if(nextUsers.count < Constants.thresholdToReloadUsers){
            reloadNextUsers()
        }
        if nextUsers.isEmpty {
            noMoreUsers()
            return nil
        } else {
            let user = nextUsers.removeFirst()
            currentUser = user
            user.displayPosts({ (posts: [Post]) in
                for post in posts {
                    if !post.isYoutube() && !SpotifyHelper.loggedIn() {
                        self.currentUser = nil
                        self.consumeUser()
                        print("Spotify user dissmissed")
                        return
                    }
                }
                self.display(user)
            })
        }
        return currentUser
    }

    func prepare(post : Post) {
        currentPost = post
        sptPlayerView.hidden = post.isYoutube()
        ytPlayerView.hidden = !post.isYoutube()
    }
    
    func display(user : User){
        currentPosts = user.posts!
        descriptionView.text = user["description"] as? String ?? ""
        age.text = String(user["age"] as! Int)
        sex.text = user["sex"] as! Bool ? "Man" :  "Woman"
        waitingView.hidden = true
        nextTrack(true)
    }
    
    
    func nextTrack(first : Bool){
        if currentPost != nil {
            pause()
            currentPost = nil
        }
        if (!currentPosts.isEmpty){
            let post = currentPosts.removeFirst()
            prepare(post)
            waiting = true
            post.playInHome(self, first: first)
        } else {
            print("no more posts")
        }
    }

    @IBAction func nextPost(sender: AnyObject) {
        nextTrack(false)
    }
    
    func pause() {
        if currentPost!.isYoutube() {
            ytPlayerView.pauseVideo()
        } else {
            SpotifyHelper.pause()
        }
    }
}

extension HomeViewController : YTPlayerViewDelegate {

    public func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState) {
        if (state.rawValue == Constants.ytEnded){
            nextPost(self)
        } else if (state.rawValue == Constants.ytQueued){
            ytPlayerView.playVideo()
        }
    }

}

extension HomeViewController : SPTAudioStreamingPlaybackDelegate {
    
    public func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        if isPlaying && waiting! {
            waiting = false
            SpotifyHelper.player.seekToOffset(Double(currentPost!.start!), callback: nil)
        }
    }
}



