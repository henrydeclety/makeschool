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
    public var isLoggedInSpoti : Bool?
    
    static func findUsersQuery() -> PFQuery {
        let userquery = PFUser.query()?.whereKey("objectId", notEqualTo: current().objectId!)
        return userquery!
    }
    
    public static func current() -> User {
        return PFUser.currentUser() as! User
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
    
    func saveLocations(locations : [CLLocation]) {
        let current = PFUser.currentUser()
        for location in locations {
            current!["location"] = PFGeoPoint(location: location)
            current!.saveInBackgroundWithBlock({ (success, error) in
                if !success {
                    print("Error while saving location")
                }
            })
        }
    }
    
    func getFbProfilePicURL() -> String? {
        if let id = fbID {
            return "http://graph.facebook.com/\(id)/picture?type=large"
        } else {
            return nil
        }
    }
    
    func loggedInSpotify() {
        isLoggedInSpoti = true
    }
    
    func isSpotifyUser() -> Bool {
        if let bool = isLoggedInSpoti {
            return bool
        } else {
            return false
        }
    }
    
    func displayPosts(callback : ([Post]) -> Void ) {
        Post.query(self).findObjectsInBackgroundWithBlock({ (results :[PFObject]?, error : NSError?) in
            guard error == nil else {
                print("Error while fetching posts from Parse")
                return
            }
            self.posts = results as? [Post] ?? []
            callback(self.posts!)
            
            
            
            
        })
    }

    public func saveToParse(block: PFBooleanResultBlock?) {
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