//
//  AppDelegate.swift
//  test
//
//  Created by Henry on 7/13/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtilsV4
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var parseLoginHelper: ParseLoginHelper!
    
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error, signUp in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let _ = user {
                // if login was successful, display the TabBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeController =  storyboard.instantiateViewControllerWithIdentifier("HomeController") as! UINavigationController
                let finishSignUp = storyboard.instantiateViewControllerWithIdentifier(Constants.finishSignUp)
                let root = self.window?.rootViewController as! PFLogInViewController
                let destination = signUp ? finishSignUp : homeController
                let current = signUp ? root.signUpController! : root
                current.presentViewController(destination, animated:true, completion:nil)
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //parse initialization
        let configuration = ParseClientConfiguration {
            $0.applicationId = "myApp"
            $0.server = "https://myApp-meet.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
        
        //public read and private write
        let acl = PFACL()
        acl.publicReadAccess = true
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        // Initialize Facebook
        // 1
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        
        //SetUp Firebase
        FIRApp.configure()
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (user, error) in
            guard error == nil else {
                ErrorHandling.defaultErrorHandler(error!)
                return
            }
//            let isAnonymous = user!.anonymous  // true
//            let uid = user!.uid
        })

        // check if we have logged in user
        // 2
        let user = PFUser.currentUser()
        
        let startViewController: UIViewController
        
        if (user != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("HomeController") as! UINavigationController
        } else {
            startViewController = logInController()
        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
        
        setUpSpotify()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    
    //MARK: Facebook Integration
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if sourceApplication! == "com.spotify.client" {
            // Ask SPTAuth if the URL given is a Spotify authentication callback
            SPTAuth.defaultInstance().canHandleURL(url)
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url) { (error, session) in
                if (error != nil){
                    print(error.localizedDescription)
                    ErrorHandling.defaultErrorHandler(error)
                    return
                } else {
                    SPTAuth.defaultInstance().session = session
                    (PFUser.currentUser()! as! User).loggedInSpotify()
                    
                    
                    let profileTest = (self.window!.rootViewController as! UINavigationController).visibleViewController
                    if let success = profileTest as? ProfileViewController {
                        success.updateLogin()
                    }
                }
            }
            return true
        } else {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    func logInController() -> PFLogInViewController {
        let loginViewController = PFLogInViewController()
        let signUpViewController = PFSignUpViewController()
        
        loginViewController.delegate = parseLoginHelper
        signUpViewController.delegate = parseLoginHelper
        
        signUpViewController.fields = [.Additional,.Default]
        loginViewController.fields = [.Facebook, .Default]
        signUpViewController.emailAsUsername = true
        
        signUpViewController.signUpView?.signUpButton?.setTitle("Continue", forState: UIControlState.Normal)
        let ageField = signUpViewController.signUpView?.additionalField
        ageField?.keyboardType = UIKeyboardType.NumberPad
        ageField?.placeholder = "age"
        loginViewController.signUpController = signUpViewController
        return loginViewController
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }


    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setUpSpotify() {
        let instance = SPTAuth.defaultInstance()
        instance.clientID = Constants.spotifyClientID
        instance.redirectURL = NSURL(string: Constants.spotifyRedirectedUrl)
        instance.requestedScopes = [SPTAuthStreamingScope]
    }

}

