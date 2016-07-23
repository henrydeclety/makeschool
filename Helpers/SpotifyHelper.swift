//
//  SpotifyHelper.swift
//  myApp
//
//  Created by Henry Declety on 7/22/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation

public class SpotifyHelper {
    
    var player : SPTAudioStreamingController?
    var session : SPTSession?
    
    public func playUsingSession(session : SPTSession, trackId : String){
        if (player == nil){
            player = SPTAudioStreamingController.sharedInstance()
        }
        
        do {
            try player!.startWithClientId(SPTAuth.defaultInstance().clientID)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        player?.loginWithAccessToken(session.accessToken)
        
        let trackURI : NSURL = NSURL(string: "spotify:track:58s6EuEYJdlb0kO7awm3Vp")!
        player?.playURIs([trackURI], fromIndex: 0, callback: { (error) in
            if (error != nil){
                NSLog("*** Auth error: %@", error)
                return
            }
        })
    }
    
    public func launchLogIn(application : UIApplication) {
        let instance = SPTAuth.defaultInstance()
        instance.clientID = "3d7b004f129841b5bc0c8ac4797466d7"
        instance.redirectURL = NSURL(string: "musicsocializerhd://callback/")
        instance.requestedScopes = [SPTAuthStreamingScope]
        
        // Construct a login URL and open it
        let loginURL : NSURL = instance.loginURL
        
        // Opening a URL in Safari close to application launch may trigger
        // an iOS bug, so we wait a bit before doing so.
        UIApplication.sharedApplication().performSelector(#selector(UIApplication.openURL(_:)), withObject: loginURL, afterDelay: 0.1)
    }
    
    public func setSession(session : SPTSession) {
        self.session = session
        playUsingSession(session, trackId: "")
    }
}