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
    
    public func playInHome(sender : HomeViewController, first : Bool) {
        if isYoutube() {
            let dico = Constants.ytParams()
            dico.setObject(self["start"]! as! Float, forKey: "start")
            dico.setObject(self["end"]! as! Float, forKey: "end")
            if (first){
                sender.playerView.loadWithVideoId(self["videoID"] as! String, playerVars: dico as [NSObject : AnyObject])
            } else {
                sender.playerView.cueVideoById(self["videoID"] as! String, startSeconds: self["start"]! as! Float, endSeconds: self["end"]! as! Float, suggestedQuality: YTPlaybackQuality.Auto)
            }
        } else {
//            self.play(NSURL(string: self["playableURI"] as! String)!, self["start"]! as! Float)
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