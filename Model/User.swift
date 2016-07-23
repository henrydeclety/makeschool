//
//  User.swift
//  myApp
//
//  Created by Henry on 7/18/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation
import Parse

public class User : PFUser {

    var posts : [Post]?
    public var fbID : String?
    public var ageMin : Int?
    public var ageMax : Int?
    public var birthday : String?
    public var sex : Bool?
    public var firstName : String?
    public var lastName : String?
    public var about : String?
    
    static func findUsersQuery() -> PFQuery {
        let userquery = PFUser.query()
        return userquery!
    }
    
    func age() -> Int? {
        /*
        if let birth = birthday {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let year =  components.year
            let month = components.month
            let day = components.day
        }*/
        return nil
    }
    
    func getFbProfilePicURL() -> String? {
        if let id = fbID {
            return "http://graph.facebook.com/\(id)/picture?type=large"
        } else {
            return nil
        }
    }
    
    func getPosts(sender : HomeViewController) {
            findLinksQuery().findObjectsInBackgroundWithBlock({ (results :[PFObject]?, error : NSError?) in
                guard error == nil else {
                    print("Error while fetching posts from Parse")
                    return
                }
                self.posts = results as? [Post] ?? []
                if (!(self.posts?.isEmpty)!) {
                    sender.display(self)
                }
            })
    }
    
    func findLinksQuery() -> PFQuery {
        let linksquery = PFQuery(className: "Post")
        linksquery.whereKeyExists("videoID")
        linksquery.whereKey("user", equalTo: self)
        return linksquery
    }
    
    func isSpotifyUser() -> Bool {
        return true
    }
    
    public override func saveInBackgroundWithBlock(block: PFBooleanResultBlock?) {
        self["fbID"] = fbID!
        self["sex"] = sex!
        self["firstName"] = firstName!
        self["lastName"] = lastName!
        self["ageMin"] = ageMin
        self["ageMax"] = ageMax
        if let description = about {
            self["description"] = description
        }
        if let age = age() {
            self["age"] = age
        }
        super.saveInBackgroundWithBlock(block)
    }

}