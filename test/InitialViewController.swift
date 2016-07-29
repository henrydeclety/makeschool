//
//  InitialViewController.swift
//  myApp
//
//  Created by Henry Declety on 7/26/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var sex: UISegmentedControl!
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let current = User.current()
        current.firstName = firstName.text
        current.lastName = lastName.text
        current.sex = sex.selectedSegmentIndex == 0
        current.saveToParse { (success, error) in
            if !success {
                ErrorHandling.defaultErrorHandler(error!)
            }
        }
        performSegueWithIdentifier("Home", sender: self)
    }
}
