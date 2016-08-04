//
//  SettingsViewController.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse
import RZTransitions

class SettingsViewController : UIViewController {
    
    var pushPopInteractionController : RZTransitionInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()
        pushPopInteractionController = SwipeInteractionControllerHelper(controller: self)
        if let vc = pushPopInteractionController as? RZBaseSwipeInteractionController {
            vc.nextViewControllerDelegate = self
            vc.attachViewController(self, withAction: .Present)
            RZTransitionsManager.shared().setInteractionController( vc, fromViewController:self.dynamicType, toViewController:nil, forAction: .PushPop);
        }
        
//        RZTransitionsManager.shared().setAnimationController( RZCardSlideAnimationController(),
//                                                              fromViewController:self.dynamicType,
//                                                              forAction:.PushPop);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("appeared")
    }
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        presentViewController(AppDelegate().logInController(), animated: true, completion: nil)
    }
    
}

extension SettingsViewController : RZTransitionInteractionControllerDelegate {
    
    func nextViewControllerForInteractor(interactor: RZTransitionInteractionController!) -> UIViewController! {
         
        return MatchesViewController()
    }
    
}
