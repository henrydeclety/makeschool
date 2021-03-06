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
    public static let ytEnded = 1
    public static let ytQueued = 5

    public static let finishSignUp = "EndOfSignUp"
    public static let home = "HomeController"
    
    public static let fbGraphRequestParameters : [NSObject : AnyObject]! = ["fields": "id, name, first_name, last_name, email, age_range, gender, birthday, about, bio"]

    
    public static func ytParams() -> NSMutableDictionary{
        let ytParams = NSMutableDictionary()
        ytParams.setObject(3, forKey: "iv_load_policy")
        ytParams.setObject(1, forKey: "playsinline")
        ytParams.setObject(0, forKey: "rel")
        ytParams.setObject("http://www.youtube.com", forKey: "origin")
        return ytParams
    }
    
    public static func noMoreUsersAlert() -> UIAlertController {
        let controller = UIAlertController(title: nil, message: "No more users available", preferredStyle: .Alert)
        let button = UIAlertAction(title: "OK", style: .Default, handler: nil)
        controller.addAction(button)
        return controller
    }
    
    public static let emojis : [String] = ["😶","😳","🙌🏽","😍","😎","😶","😳","🙌🏽","😍","😎","😶","😳","🙌🏽"]
    
    public static let first = NSIndexPath(forItem: 1, inSection: 0)
    public static let destination = NSIndexPath(forItem: 5, inSection: 0)
    public static let last = NSIndexPath(forItem: emojis.count-2, inSection: 0)

    
//    public static func tapGestureDissmissKeyboard(sender : UIViewController) {
//        let tap = UITapGestureRecognizer(target: sender, action: #selector((void) -> sender.view.endEditing(true)))
//        sender.view.addGestureRecognizer(tap)
//    }
    
//    public static func dissmissKeyboard(sender : UIViewController) -> (void) -> (void) {
//        return
//    }
    
}