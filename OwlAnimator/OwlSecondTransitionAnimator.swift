//
//  OwlSecondTransitionAnimator.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 15/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

//
//  OwlTransitionAnimator.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 15/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class OwlSecondTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    weak var containerView: UIView?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        containerView = transitionContext.containerView()
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! BigOwlController
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ViewController
        
        containerView?.addSubview(toVC.view)
       
        animateToVC(toVC: toVC, fromVC: fromVC)
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
    }
    
    private func animateToVC(toVC vc: ViewController, fromVC: UIViewController) {
        fromVC.view.backgroundColor = UIColor.whiteColor()
        UIView.animateWithDuration(1.0, animations: {
            vc.owlContainer.transform = CGAffineTransformMakeScale(1, 1)
            vc.owlImage.transform = CGAffineTransformMakeScale(1, 1)
            }) { _ in
                let reversePath = vc.owlPath.bezierPathByReversingPath()
                let anim = CAKeyframeAnimation(keyPath: "position")
                anim.rotationMode = kCAAnimationPaced
                anim.fillMode = kCAFillModeForwards
                anim.removedOnCompletion = false
                anim.duration = self.transitionDuration(self.transitionContext)
                
                anim.path = reversePath.CGPath
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    self.transitionContext?.completeTransition(true)
                }
                vc.owlContainer.layer.addAnimation(anim, forKey: "circle")
                vc.owlImage.layer.addAnimation(anim, forKey: "circle")
                CATransaction.commit()

        }
    }
    
}
