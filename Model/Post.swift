//
//  Post.swift
//  myApp
//
//  Created by Henry on 7/18/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation
import Parse


class Post : PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return "Post"
    }
    
    
}