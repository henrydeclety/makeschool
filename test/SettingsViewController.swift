//
//  SettingsViewController.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        presentViewController(AppDelegate().logInController(), animated: true, completion: nil)
    }
    
}
