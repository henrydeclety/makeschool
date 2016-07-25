//
//  SpotifyHelper.swift
//  myApp
//
//  Created by Henry Declety on 7/22/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation
import Parse

public class SpotifyHelper  : UIViewController{
    
    static var player : SPTAudioStreamingController = SPTAudioStreamingController.sharedInstance()
    var logInViewController : SPTAuthViewController?
    var currentSender : UIViewController?
    
    static public func play(track : NSURL){
        if !player.loggedIn {
            do {
                try player.startWithClientId(SPTAuth.defaultInstance().clientID)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            SPTAudioStreamingController.sharedInstance().loginWithAccessToken(SPTAuth.defaultInstance().session.accessToken)
        }
        
//        let trackURI : NSURL = NSURL(string: "spotify:track:58s6EuEYJdlb0kO7awm3Vp")!
        player.playURIs([track], fromIndex: 0, callback: { (error) in
            if (error != nil){
                NSLog("*** Auth error: %@", error)
                return
            }
        })
    }
    
    static public func pause() {
        player.setIsPlaying(false,callback : nil)
    }
    
    static public func play() {
        player.setIsPlaying(true, callback: nil)
    }
    
    public static func loggedIn() -> Bool{
        return (PFUser.currentUser() as! User).isSpotifyUser()
//        return player.loggedIn
    }
    
    public static func isPlaying() -> Bool {
        return player.currentTrackURI != nil
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
    
    
    
}

extension SpotifyHelper : SPTAuthViewDelegate {
    public func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {

    }
    
     public func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        
        
    }
    
     public func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        
        
    }
}