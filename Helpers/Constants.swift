//
//  Constants.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation

public class Constants {

    public static let NotDetermined : Int32 = 0
    public static let Restricted : Int32 = 1
    public static let Denied : Int32 = 2
    
    public static let fbGraphRequestParameters : [NSObject : AnyObject]! = ["fields": "id, name, first_name, last_name, email, age_range, gender"]

    
}