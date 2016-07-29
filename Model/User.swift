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
    public var trackInfos : String?
    
    static func findUsersQuery() -> PFQuery {
        let userquery = PFUser.query()?.whereKey("objectId", notEqualTo: current().objectId!)
        userquery?.whereKey("hasContent", equalTo: true)
        return userquery!
    }
    
    public static func current() -> User {
        return PFUser.currentUser() as! User
    }
    
    func age() -> Int {
        
        if let _ = birthday {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let year =  components.year
            let month = components.month
            let day = components.day
            return 0
        } else {
            return (ageMax! + ageMin!)/2
        }
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
    
    func removeSpotifyTracks() {
        guard posts != nil else {
            print("The posts are not loaded or nil")
            return
        }
        var i = 0
        for bit in getTracksInfos().characters {
            if bit == "0" {
                posts?.removeAtIndex(i)
            } else {
                i = i + 1
            }
        }
    }
    
    func getSpotifyURIs() -> [NSURL] {
        guard posts != nil else {
            print("The posts are not loaded or nil")
            return []
        }
        var result : [NSURL] = []
        var i = 0
        for bit in getTracksInfos().characters {
            if bit == "0" {
                // MARK: -
                result.append(posts![i].getPlayableURI())
            }
            i = i + 1
        }
        return result
    }
    
    func getPosts(purpose : String, callback : (User) -> Void) {
        Post.query(self).findObjectsInBackgroundWithBlock({ (results :[PFObject]?, error : NSError?) in
            guard error == nil else {
                print("Error while fetching posts from Parse")
                return
            }
            self.posts = results as? [Post] ?? []
            if !SpotifyHelper.loggedIn() && purpose != "profile" {
                self.removeSpotifyTracks()
            }
            callback(self)
        })
    }
    
    func getTracksInfos() -> String {
        if let infos = trackInfos {
            return infos
        } else {
            trackInfos = self["trackInfos"] as? String
            return trackInfos!
        }
    }
    
    func nbOfSpotifyTracks() -> Int {
        var result = 0
        for bit in getTracksInfos().characters {
            if bit == "0" {
                result = result + 1
            }
        }
        return result
    }

    public func saveToParse(block: PFBooleanResultBlock?) {
        self["sex"] = sex!
        self["firstName"] = firstName!
        self["lastName"] = lastName!
        self["ageMin"] = ageMin
        self["ageMax"] = ageMax
        if let id = fbID {
            self["fbID"] = id
        }
        if let description = about {
            self["description"] = description
        }
        if let b = birthday {
            self["birthday"] = b
        }
        super.saveInBackgroundWithBlock(block)
    }

}