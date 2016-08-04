//
//  SwipeInteractionController.swift
//  myApp
//
//  Created by Henry Declety on 8/2/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import RZTransitions


class SwipeInteractionControllerHelper : RZBaseSwipeInteractionController {

    var controller : UIViewController!
    var width : CGFloat!
    var height : CGFloat!

    init(controller : UIViewController) {
        self.controller = controller
        controller.view.window?.bounds
        self.width = controller.view.bounds.width
        self.height = controller.view.bounds.height
    }
    
    func fullTranslation() -> CGFloat {
        return (height*0.4 + width*0.6)/100
    }
    
//    - width : 320.0
//    - height : 568.0
    
    override func swipeCompletionPercent() -> CGFloat {
        return 1
    }
    
    override func translationPercentageWithPanGestureRecongizer(panGestureRecognizer: UIPanGestureRecognizer!) -> CGFloat {
        let translation = panGestureRecognizer.translationInView(controller!.view)
        print(translation.x, translation.y, (translation.x * 0.6 + translation.y * 0.4)/fullTranslation())
        return translationWithPanGestureRecongizer(panGestureRecognizer)/fullTranslation()
    }
    
    override func translationWithPanGestureRecongizer(panGestureRecognizer: UIPanGestureRecognizer!) -> CGFloat {
        let translation = panGestureRecognizer.translationInView(controller!.view)
        panGestureRecognizer.setTranslation(CGPoint.zero, inView: controller?.view)
        return translation.x * 0.6 + translation.y * 0.4
    }
    
    override func isGesturePositive(panGestureRecognizer: UIPanGestureRecognizer!) -> Bool {
        return panGestureRecognizer.translationInView(controller!.view).x > 0
    }
    
}
