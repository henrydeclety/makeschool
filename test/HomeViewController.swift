//
//  HomeViewController.swift
//  myApp
//
//  Created by Henry on 7/18/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
import youtube_ios_player_helper

public class HomeViewController: UIViewController {

    
    @IBOutlet weak var sptPlayerView: SpotifyPlayerView!
    @IBOutlet weak var sptName: UILabel!
    @IBOutlet weak var sptArtist: UILabel!
    @IBOutlet weak var sptNext: UIButton!
    @IBOutlet weak var sptPlayPause: UIButton!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var noMorePosts: UIView!
    @IBOutlet weak var lookingForUsers: UIView!
    
    var waiting : Bool?
    var nextUsers : [User] = []
    var currentPosts : [Post] = []
    var currentPost : Post?
    var currentUser : User?
    private var firstRound = true
    var locationHelper = LocationManager()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        ytPlayerView.delegate = self
        reloadNextUsers()
        locationHelper.test()
        noMorePosts.hidden = true
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            
        }
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
            consumeUser()
        }
    }
    
    func noMoreUsers() {
        lookingForUsers.hidden = false
        consumeUser()
    }
    
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>){
        guard SpotifyHelper.isPlaying() else {
            return
        }
        if keyPath == "currentPlaybackPosition" {
            let time = Int((object as! SPTAudioStreamingController).currentPlaybackPosition)
            if (time >= currentPost?.end!) {
                pause()
                nextPost(self)
           } else if time < currentPost!.start {
                SpotifyHelper.player.seekToOffset(Double(currentPost!.start!), callback: nil)
           }
        }
    }
    
    func prepareForSpotifyPlay() {
        if (Int(SpotifyHelper.player.currentTrackIndex) == currentUser!.nbOfSpotifyTracks() - 1){
            SpotifyHelper.removeObserver(self)
            SpotifyHelper.pause()
        } else {
            SpotifyHelper.next()
        }
    }
    
    func reloadNextUsers() {
        User.findUsersQuery().findObjectsInBackgroundWithBlock({ (results : [PFObject]?, error : NSError?) in
            guard error == nil else {
                print("Error while fetching users")
                return
            }
            self.nextUsers = self.nextUsers + (results as? [User] ?? [])
            
            if(self.currentUser == nil){
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
        } else {
            lookingForUsers.hidden = true
            let user = nextUsers.removeFirst()
            currentUser = user
            user.getPosts("home", callback: display)
        }
        return currentUser
    }

    func prepare(post : Post) {
        currentPost = post
        noMorePosts.hidden = true
        sptPlayerView.hidden = post.isYoutube()
        ytPlayerView.hidden = !post.isYoutube()
    }
    
    func display(user : User){
        currentPosts = user.posts!
        descriptionView.text = user["description"] as? String ?? ""
        age.text = user["age"] as? String ?? ""
        if let sex = user["sex"] as? Bool {
            self.sex.text = sex ? "Man" :  "Woman"
        } else {
            self.sex.text = ""
        }
        if user.getTracksInfos().containsString("0") && SpotifyHelper.loggedIn() {
            SpotifyHelper.play(user.getSpotifyURIs(), sender: self)
            SpotifyHelper.addObserver(self)
        }
        nextTrack(true)
    }
    
    
    func nextTrack(first : Bool){
        if currentPost != nil {
            pause()
            currentPost = nil
        }
        if currentPosts.isEmpty {
            noMorePosts.hidden = false
        } else {
            prepare(currentPosts.removeFirst())
            waiting = true
            play(currentPost!, first: first)
        }
    }

    @IBAction func nextPost(sender: AnyObject) {
        if !currentPost!.isYoutube() {
            prepareForSpotifyPlay()
        }
        nextTrack(false)
    }
    
    func pause() {
        if currentPost!.isYoutube() {
            ytPlayerView.pauseVideo()
        } else {
//            SpotifyHelper.pause()
        }
    }
    
    public func play(post : Post, first : Bool) {
        post.load()
        if post.isYoutube() {
            let dico = getYtParams(post)
            if (first){
                ytPlayerView.loadWithVideoId(post.videoID!, playerVars: dico as [NSObject : AnyObject])
            } else {
                ytPlayerView.cueVideoById(post.videoID!, startSeconds: Float(post.start!), endSeconds: Float(post.end!), suggestedQuality: YTPlaybackQuality.Auto)
            }
        } else {
            sptName.text = post.name
            sptArtist.text = post.artist
            SpotifyHelper.play()
//            SpotifyHelper.play(post.playableURI!, sender: self)
        }
    }
    
    func getYtParams(post : Post) -> NSMutableDictionary {
        let dico = Constants.ytParams()
        dico.setObject(0, forKey: "showinfo")
        dico.setObject(0, forKey: "controls")
        dico.setObject(Float(post.start!), forKey: "start")
        dico.setObject(Float(post.end!), forKey: "end")
        return dico
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



