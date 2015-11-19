//
//  OwlsController.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 16/11/15.
//  Copyright (c) 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class OwlsController: UIViewController {

    @IBOutlet weak var owlsContainer: UIView!
    
    var owls = [
        "Owl1.png",
        "Owl2.png",
        "Owl3.jpeg",
        "Owl4.jpg",
        "Owl5.png",
        "Owl6.png",
        "Owl7.png",
        "Owl8.jpg",
        "Owl9.png",
        "Owl10.png",
        "Owl11.png"
    ]
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: "owlClicked")
        owlsContainer.addGestureRecognizer(tap)
        
    }
    
    var clicked = false
    
    func owlClicked() {
//        let spring = CASpringAnimation(keyPath: "position")
//        spring.damping = 5
//        spring.fromValue = owlsContainer.layer.position.y
//        spring.toValue = owlsContainer.layer.position.y - 100.0
//        spring.initialVelocity = 10.0
//        spring.duration = spring.settlingDuration
//        owlsContainer.layer.addAnimation(spring, forKey: nil)
        
        if clicked {
            (-100,0)
            (100, 0)
            let x: [CGFloat] = [-100.0, -75.0, 0.0, 75.0, 100.0, 75.0, 0.0, -75.0]
            var y: [CGFloat] = [0.0, -75.0, -100.0, -75.0, 0.0, 75.0, 100.0, 75.0]
            var i = 0
            for v in owlsContainer.subviews {
                print(i)
//                UIView.animateWithDuration(0.5, delay: NSTimeInterval(CGFloat(i) * CGFloat(0.1)), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: [], animations: {
//                    v.frame = CGRectOffset(v.frame, x[i], y[i])
//                    }, completion: nil)
                let spring = CASpringAnimation(keyPath: "position")
                spring.damping = 3
                spring.stiffness = 1.0
                spring.initialVelocity = 3.0
                spring.fillMode = kCAFillModeForwards
                spring.removedOnCompletion = false
                spring.fromValue = NSValue(CGPoint: CGPoint(x: v.center.x + x[i], y: v.center.y - y[i]))
                spring.toValue = NSValue(CGPoint: v.center)
                spring.duration = spring.settlingDuration
                v.layer.addAnimation(spring, forKey: nil)
                i++
            }
        } else {
            let x: [CGFloat] = [100.0, 75.0, 0.0, -75.0, -100.0, -75.0, 0.0, 75.0]
            var y: [CGFloat] = [0.0, 75.0, 100.0, 75.0, 0.0, -75.0, -100.0, -75.0]
            var i = 0
            for v in owlsContainer.subviews {
//                UIView.animateWithDuration(0.5, delay: NSTimeInterval(CGFloat(i) * CGFloat(0.1)), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: [], animations: {
//                    v.frame = CGRectOffset(v.frame, x[i], y[i])
//                    }, completion: nil)
//                i++
                let spring = CASpringAnimation(keyPath: "position")
                spring.damping = 3
                spring.fromValue = NSValue(CGPoint: v.center)
                spring.toValue = NSValue(CGPoint: CGPoint(x: v.center.x + x[i], y: v.center.y - y[i]))
                spring.initialVelocity = 3.0
                spring.fillMode = kCAFillModeForwards
                spring.removedOnCompletion = false
                spring.duration = spring.settlingDuration
                v.layer.addAnimation(spring, forKey: nil)
                i++
            }
        }
        clicked = !clicked
    }
    
}

extension OwlsController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OwlCell", forIndexPath: indexPath)
        cell.imageView!.image = UIImage(named: owls[indexPath.row])!
        return cell as UITableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("OwlCell", forIndexPath: indexPath)
        let owlImage = cell.imageView!
        
        let owlToMove = UIImageView(frame: CGRectOffset(owlImage.convertRect(owlImage.frame, fromView: cell), -cell.imageView!.frame.width / 2, -cell.imageView!.frame.height / 2))
        owlToMove.image = UIImage(named: owls[indexPath.row])!
        view.addSubview(owlToMove)
        
        view.layoutIfNeeded()
        
        animateOwlToNest(owlToMove)
    }
    
    private func animateOwlToNest(owl: UIView) -> UIBezierPath {
        let owlPath = UIBezierPath()
        owlPath.moveToPoint(owl.center)
        owlPath.addQuadCurveToPoint(owlsContainer.center, controlPoint: P(view.center.x, owl.center.y))
        
        let pathLayer = CAShapeLayer()
        pathLayer.borderColor = UIColor.blueColor().CGColor
        pathLayer.fillColor = UIColor.clearColor().CGColor
        
        pathLayer.removeFromSuperlayer()
        pathLayer.path = owlPath.CGPath
        pathLayer.removeFromSuperlayer()
        view.layer.addSublayer(pathLayer)

        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        anim.duration = 0.5
        
        anim.path = owlPath.CGPath
        
        owl.layer.addAnimation(anim, forKey: "circle")
        
        return owlPath
    }
    
//    private func moveOwl(path: UIBezierPath, onFinished: () -> ()) {
//        let anim = CAKeyframeAnimation(keyPath: "position")
//        anim.rotationMode = kCAAnimationPaced
//        anim.fillMode = kCAFillModeForwards
//        anim.removedOnCompletion = false
//        anim.duration = 0.5
//        
//        anim.path = path.CGPath
//        
//        CATransaction.begin()
//        CATransaction.setCompletionBlock {
//            onFinished()
//        }
//        owlContainer.layer.addAnimation(anim, forKey: "circle")
//        owlImage.layer.addAnimation(anim, forKey: "circle")
//        CATransaction.commit()
//    }
}

extension OwlsController : UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return owls.count
    }
}
