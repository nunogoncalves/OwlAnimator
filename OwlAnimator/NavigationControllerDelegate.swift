//
//  NavigationControllerDelegate.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 15/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is ViewController {
            return OwlFirstTransitionAnimator()
        }
        
        if toVC is ViewController {
            return OwlSecondTransitionAnimator()
        }
        
        return nil
    }
    

    
}
