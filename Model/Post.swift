//
//  Post.swift
//  myApp
//
//  Created by Henry on 7/18/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation
import Parse
import youtube_ios_player_helper


public class Post : PFObject, PFSubclassing {
    
    var videoID: String?
    var thumbnail : String?
    var name : String!
    var artist : String?
    var isyoutube: Bool!
    var totalDuration : Int?
    var playableURI : NSURL?
    var start : Int?
    var end : Int?
    
    public init(title : String, videoID : String, thumbnail : String) {
        super.init()
        name = title
        isyoutube = true
        self.videoID = videoID
        self.thumbnail = thumbnail
    }
    
    public override init() {
        super.init()
    }
    
    public func isYoutube() -> Bool {
        if let bool = isyoutube {
            return bool
        } else {
            isyoutube = self["isYoutube"] as! Bool
            return isyoutube
        }
    }
    
    public func load() {
        start = self["start"]! as? Int
        end = self["end"]! as? Int
        if isYoutube() {
            videoID = self["videoID"] as? String
        } else {
            playableURI = NSURL(string : (self["playableURI"] as? String)!)
            name = self["name"] as? String
            artist = self["artist"] as? String
        }
    }
    
    public func playInHome(sender : HomeViewController, first : Bool) {
        load()
        if isYoutube() {
            let dico = Constants.ytParams()
            dico.setObject(Float(start!), forKey: "start")
            dico.setObject(Float(end!), forKey: "end")
            if (first){
                sender.ytPlayerView.loadWithVideoId(videoID!, playerVars: dico as [NSObject : AnyObject])
            } else {
                sender.ytPlayerView.cueVideoById(videoID!, startSeconds: Float(start!), endSeconds: Float(end!), suggestedQuality: YTPlaybackQuality.Auto)
            }
        } else {
            sender.sptName.text = name
            sender.sptArtist.text = artist
            SpotifyHelper.play(playableURI!, sender: sender as SPTAudioStreamingPlaybackDelegate)
        }
    }
    
    public init(name : String, artist : String, playableURI : NSURL, duration : Int) {
        super.init()
        self.name = name
        self.artist = artist
        isyoutube = false
        self.playableURI = playableURI
        self.totalDuration = duration
    }
    
    public static func parseClassName() -> String {
        return "Post"
    }
    
    public static func query(user : User) -> PFQuery {
        let linksquery = Post.query()
        linksquery!.whereKey("user", equalTo: user)
        return linksquery!
    }
    
    public func save(start start : Int, end : Int, duration : Int) {
        self["user"] = PFUser.currentUser()
        self["start"] = start
        self["end"] = end
        self["duration"] = duration
        self["isYoutube"] = isYoutube()
        if isYoutube() {
            self["thumbnail"] = thumbnail!
            self["videoID"] = videoID
            self["name"] = name
        } else {
            self["playableURI"] = playableURI?.absoluteString
            self["name"] = name
            self["artist"] = artist
        }
        saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if (success){
                print("Post succefully uploaded")
            } else {
                print("Post upload fail")
            }
        }
        
    }
    
}