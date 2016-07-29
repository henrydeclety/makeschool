//
//  SpotifyHelper.swift
//  myApp
//
//  Created by Henry Declety on 7/22/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse
import Bond

public class SpotifyHelper  : UIViewController{
    
    static var player : SPTAudioStreamingController = SPTAudioStreamingController.sharedInstance()
    var logInViewController : SPTAuthViewController?
    var currentSender : UIViewController?
    
    static public func setUp() {
        if !player.loggedIn {
            do {
                try player.startWithClientId(SPTAuth.defaultInstance().clientID)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        SPTAudioStreamingController.sharedInstance().loginWithAccessToken(SPTAuth.defaultInstance().session.accessToken)
    }
    
    static public func setDelegate(sender : SPTAudioStreamingPlaybackDelegate) {
        player.playbackDelegate = sender
    }
    
    static public func play(tracks : [NSURL], sender : SPTAudioStreamingPlaybackDelegate){
        setUp()
        setDelegate(sender)
        player.playURIs(tracks, fromIndex: 0, callback: nil)
        pause()
    }
    
    static public func next(){
        player.skipNext(nil)
    }
//    static public func play(track : NSURL, sender : SPTAudioStreamingPlaybackDelegate){
//        setUp()
//        setDelegate(sender)
//        player.playURIs([track], fromIndex: 0, callback: nil)
//    }
    
    static public func pause() {
        player.setIsPlaying(false,callback : nil)
    }
    
    static public func play() {
        player.setIsPlaying(true, callback: nil)
    }
    
    public static func loggedIn() -> Bool{
        return SPTAuth.defaultInstance().session != nil
    }
    
    public static func isSet() -> Bool {
        return player.currentTrackURI != nil
    }
    
    public static func isPlaying() -> Bool {
        return player.isPlaying
    }
    
    public func logIn(sender : UIViewController) {
        logInViewController = SPTAuthViewController.authenticationViewController()
        logInViewController?.delegate = self
        // Construct a login URL and open it
        let loginURL : NSURL = SPTAuth.defaultInstance().loginURL
        // Opening a URL in Safari close to application launch may trigger
        // an iOS bug, so we wait a bit before doing so.
//        if UIApplication.sharedApplication().canOpenURL(NSURL(string : "spotify-action://")!){
                UIApplication.sharedApplication().performSelector(#selector(UIApplication.openURL(_:)), withObject: loginURL, afterDelay: 0.1)
//        } else {
//            sender.presentViewController(logInViewController!, animated: false, completion: nil)
//        }
    }
    
    public static func currentTime() -> String {
        return player.currentPlaybackPosition.description
    }
    
    public static func stop() {
        pause()
        do {
            try player.stop()
        } catch {
            print("Error while stopping the video")
        }
    }
    
    public static func addObserver(sender : UIViewController) {
        player.addObserver(sender, forKeyPath: "currentPlaybackPosition", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    public static func removeObserver(sender : UIViewController) {
        player.removeObserver(sender, forKeyPath: "currentPlaybackPosition")
    }
}

extension SpotifyHelper : SPTAuthViewDelegate {
    public func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {

    }
    
     public func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        
        
    }
    
     public func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        
        
    }
}
