//
//  Post.swift
//  myApp
//
//  Created by Henry on 7/18/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation
import Parse


public class Post : PFObject, PFSubclassing {

    public static func parseClassName() -> String {
        return "Post"
    }
    
    
}