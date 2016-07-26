//
//  Constants.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation
import youtube_ios_player_helper

public class Constants {

    public static let spotifyClientID = "3d7b004f129841b5bc0c8ac4797466d7"
    public static let spotifyRedirectedUrl = "musicsocializerhd://callback/"
    
    public static let thresholdToReloadUsers = 2
    
    public static let fbGraphRequestParameters : [NSObject : AnyObject]! = ["fields": "id, name, first_name, last_name, email, age_range, gender, birthday, about, bio"]

    
    public static func ytParams() -> NSMutableDictionary{
        let ytParams = NSMutableDictionary()
       // ytParams.setObject(0, forKey: "autohide")
        ytParams.setObject(1, forKey: "playsinline")
        ytParams.setObject(0, forKey: "rel")
        ytParams.setObject("http://www.youtube.com", forKey: "origin")
        return ytParams
    }
}