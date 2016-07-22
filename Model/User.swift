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
    public var age : Int?
    public var sex : Bool?
    public var firstName : String?
    public var lastName : String?

    
    static func findUsersQuery() -> PFQuery {
        let userquery = PFUser.query()
        return userquery!
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
    
    public override func saveInBackgroundWithBlock(block: PFBooleanResultBlock?) {
      //  self["age"] = age
        self["fbID"] = fbID!
        self["sex"] = sex!
        self["firstName"] = firstName!
        self["lastName"] = lastName!
        
        super.saveInBackgroundWithBlock(block)
    }

}