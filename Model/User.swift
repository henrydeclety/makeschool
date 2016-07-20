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
    
    static func findUsersQuery() -> PFQuery {
        let userquery = PFUser.query()
        return userquery!
    }
    
    func getPosts(sender : HomeViewController) {
        if (posts == nil){
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
    }
    
    func findLinksQuery() -> PFQuery {
        let linksquery = PFQuery(className: "Post")
        linksquery.whereKeyExists("videoID")
        linksquery.whereKey("user", equalTo: self)
        return linksquery
    }

}