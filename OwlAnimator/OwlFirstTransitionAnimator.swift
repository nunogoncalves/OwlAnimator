//
//  OwlTransitionAnimator.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 15/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class OwlFirstTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    weak var transitionContext: UIViewControllerContextTransitioning?
    weak var containerView: UIView?
   
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        self.containerView = transitionContext.containerView()
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ViewController
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! BigOwlController
        
        containerView?.addSubview(fromVC.view)
        
        animateFromVC(fromVC: fromVC, toVC: toVC)
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
    }
    
    private func animateFromVC(fromVC vc: ViewController, toVC: BigOwlController) {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        anim.duration = 1.0
        anim.delegate = self
        
        anim.path = vc.owlPath.CGPath
        CATransaction.begin()

        CATransaction.setCompletionBlock {
            UIView.animateWithDuration(1.0, animations: {
                vc.owlContainer.transform = CGAffineTransformMakeScale(10, 10)
                vc.owlImage.transform = CGAffineTransformMakeScale(3.334, 3.334)
                }, completion: { _ in
                    self.containerView?.addSubview(toVC.view)
                    self.transitionContext?.completeTransition(true)
            })
        }
        
        vc.owlContainer.layer.addAnimation(anim, forKey: "circle")
        vc.owlImage.layer.addAnimation(anim, forKey: "circle")
        
        CATransaction.commit()
    }

}
