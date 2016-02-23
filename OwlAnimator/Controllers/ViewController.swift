//
//  ViewController.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 15/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

func P(x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

class ViewController: UIViewController, FinishedProtocol {

    @IBOutlet weak var owlContainer: UIView!
    @IBOutlet weak var owlImage: UIImageView!
    
    let pathLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        addTapToOwl()
    }
    
    private func owlPath() -> UIBezierPath {
        let owlPath = UIBezierPath()
        owlPath.moveToPoint(owlContainer.center)
        owlPath.addQuadCurveToPoint(view.center, controlPoint: P(view.center.x, owlContainer.center.y))

//        pathLayer.strokeColor = UIColor.blueColor().CGColor
//        pathLayer.lineWidth = 1
//        pathLayer.borderWidth = 1.0
        pathLayer.borderColor = UIColor.blueColor().CGColor
        pathLayer.fillColor = UIColor.clearColor().CGColor
        
        pathLayer.removeFromSuperlayer()
        pathLayer.path = owlPath.CGPath
        view.layer.addSublayer(pathLayer)
        
        return owlPath
    }
    
    private func addTapToOwl() {
        let tap = UITapGestureRecognizer(target: self, action: "owlClicked")
        owlContainer.addGestureRecognizer(tap)
    }
    
    func owlClicked() {
        moveOwl(owlPath(), onFinished: {
            let center = self.view.center
            self.owlImage.frame = CGRectMake(center.x, center.y, self.owlImage.frame.width, self.owlImage.frame.height)
            self.view.layoutIfNeeded()
            self.expandOwl()
        })
    }
    
    private func moveOwl(path: UIBezierPath, onFinished: () -> ()) {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        anim.duration = 0.5
        
        anim.path = path.CGPath
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            onFinished()
        }
        owlContainer.layer.addAnimation(anim, forKey: "circle")
        owlImage.layer.addAnimation(anim, forKey: "circle")
        CATransaction.commit()
    }
    
    private func expandOwl() {
        let vheight = view.frame.height + owlContainer.layer.cornerRadius
        let owlHeight = owlContainer.frame.height
        
        let relation = vheight / owlHeight
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.owlContainer.transform = CGAffineTransformMakeScale(relation, relation)
            self.owlImage.transform = CGAffineTransformMakeScale(2, 2)
            }) { _ in
                let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("BigOwlController") as! BigOwlController
                nextVC.finshedDelegate = self
                self.presentViewController(nextVC, animated: false, completion: nil)
        }
    }
    
    func viewWillReappear() {
        UIView.animateWithDuration(1.0, animations: {
            self.owlContainer.transform = CGAffineTransformMakeScale(1, 1)
            self.owlImage.transform = CGAffineTransformMakeScale(1, 1)
            }) { _ in
                let reversePath = self.owlPath().bezierPathByReversingPath()
                self.moveOwl(reversePath) {
                    self.owlImage.updateConstraints()
                }
        }
    }
    
}

protocol FinishedProtocol : class {
    func viewWillReappear();
}

