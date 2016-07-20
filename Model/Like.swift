//
//  Like.swift
//  myApp
//
//  Created by Henry Declety on 7/19/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse

public class Like: PFObject, PFSubclassing {
    
    public static func parseClassName() -> String {
        return "Like"
    }
    
    //mazbe handle the case where 2 results were found
    public static func addLike(from user1 : User, to user2 : User, bool : Bool) {
        query(from: user1, to: user2).findObjectsInBackgroundWithBlock { (results, error) in
            guard error == nil && results != nil else {
                print("Error while fetching likes")
                return
            }
            if (results!.isEmpty){
                let like = PFObject(className: "Like")
                like["user1"] = user1
                like["user2"] = user2
                like["user1Like"] = bool
                like.saveInBackground() //should I alwazs use with block what happen in case of connexion problems
            } else {
                let tmp = results![0] as! Like
                if (tmp["user1"].objectId == user1.objectId!){
                    tmp["user1Like"] = bool
                } else {
                    tmp["user2Like"] = bool
                }
                tmp.saveInBackground()
            }
        }
    }
    
    public static func query(from user1 : User, to user2 : User) -> PFQuery {
        let query1 = PFQuery(className: "Like")
        query1.whereKey("user1", equalTo: user1)
        query1.whereKey("user2", equalTo: user2)
        
        let query2 = PFQuery(className: "Like")
        query2.whereKey("user1", equalTo: user1)
        query2.whereKey("user2", equalTo: user2)
        
        return PFQuery.orQueryWithSubqueries([query1,query2])
    }

}
