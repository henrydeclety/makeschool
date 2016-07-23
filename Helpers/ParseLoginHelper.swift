//
//  LocationManager.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Parse
import ParseUI

typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

/**
 This class implements the 'PFLogInViewControllerDelegate' protocol. After a successfull login
 it will call the callback function and provide a 'PFUser' object.
 */
class ParseLoginHelper : NSObject {
    static let errorDomain = "com.makeschool.parseloginhelpererrordomain"
    static let usernameNotFoundErrorCode = 1
    static let usernameNotFoundLocalizedDescription = "Could not retrieve Facebook username"
    
    let callback: ParseLoginHelperCallback
    
    init(callback: ParseLoginHelperCallback) {
        self.callback = callback
    }
}

extension ParseLoginHelper : PFLogInViewControllerDelegate {
    
    func saveUserInfo(result: [String : AnyObject], user : User) {
        // assign Facebook name to PFUser
        
        user.username = result["name"] as? String
        user.fbID = result["id"] as? String
        let age : [String : AnyObject] = (result["age_range"] as? [String : AnyObject])!
        user.ageMin = age["min"] as? Int
        user.ageMax = age["max"] as? Int
        user.birthday = result["user_birthday"] as? String
        user.firstName = result["first_name"] as? String
        user.lastName = result["last_name"] as? String
        user.sex = (result["gender"] as! String) == "male"
        user.about = result["about"] as? String
        
        // non-accessible avec mon compte : bio, about, email, birthday
        
        if let email = result["email"] as? String {
            user.email = email
        }
        
        // store PFUser
        user.saveInBackgroundWithBlock({ (success, error) -> Void in
            if (success) {
                // updated username could be stored -> call success
                self.callback(user, error)
            } else {
                // updating username failed -> hand error to callback
                self.callback(nil, error)
            }
        })
        
    }
    
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        // Determine if this is a Facebook login
        let isFacebookLogin = FBSDKAccessToken.currentAccessToken() != nil
        
        if !isFacebookLogin {
            // Plain parse login, we can return user immediately
            self.callback(user, nil)
        } else {
            // if this is a Facebook login, fetch the username from Facebook
            FBSDKGraphRequest(graphPath: "me", parameters: Constants.fbGraphRequestParameters).startWithCompletionHandler {
                (connection: FBSDKGraphRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
                if let error = error {
                    // Facebook Error? -> hand error to callback
                    self.callback(nil, error)
                }
                if (result != nil) {
                    self.saveUserInfo(result as! [String : AnyObject], user: user as! User)
                } else {
                    // cannot retrieve username? -> create error and hand it to callback
                    //            let userInfo = [NSLocalizedDescriptionKey : ParseLoginHelper.usernameNotFoundLocalizedDescription]
                    //            let noUsernameError = NSError(
                    //              domain: ParseLoginHelper.errorDomain,
                    //              code: ParseLoginHelper.usernameNotFoundErrorCode,
                    //              userInfo: userInfo
                    //            )
                    self.callback(nil, error)
                }
            }
        }
    }
    
}

extension ParseLoginHelper : PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.callback(user, nil)
    }
    
}