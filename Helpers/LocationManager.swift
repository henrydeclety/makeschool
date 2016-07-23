//
//  LocationManager.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    var manager : CLLocationManager?
    
    func test() {
        manager = CLLocationManager()
        manager?.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined : manager!.requestAlwaysAuthorization()
        default : break
        }
    }
    
}

//extension LocationManager : CLLocationManagerDelegate {
    
//  }