//
//  LocationManager.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse

class LocationManager : NSObject {
    
    var manager : CLLocationManager?
        
    func test() {
        manager = CLLocationManager()
        manager?.delegate = self
    }
    
    func saveLocation() {
        manager!.requestLocation()
        manager?.startMonitoringSignificantLocationChanges()
    }
    
}

extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined : manager.requestAlwaysAuthorization()
        case .AuthorizedAlways : saveLocation()
        default : break
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("location did fail")
//        do shit with the error or not
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location did update")
        (PFUser.currentUser() as! User).saveLocations(locations)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("location did update to from")
        (PFUser.currentUser() as! User).saveLocations([oldLocation,newLocation])
    }
  }
