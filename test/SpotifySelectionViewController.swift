//
//  SpotifySelectionViewController.swift
//  myApp
//
//  Created by Henry Declety on 7/22/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit

class SpotifySelectionViewController: UIViewController {
    
    override func viewDidLoad() {
        SpotifyHelper().logIn(self)
    }

    
    
}
