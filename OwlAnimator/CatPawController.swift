//
//  CatPawController.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 19/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class CatPawController: UIViewController {

    @IBOutlet weak var nest: UIView!
    
    var damping: Float = 0.46
    var initVel: Float = 0
    var stiffness: Float = 0
    
    var numberOfOwls = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: "nestClicked")
        nest.addGestureRecognizer(tap)
        
//        let arc = UIBezierPath()
//        arc.addArcWithCenter(nest.center, radius: 100, startAngle: 0, endAngle: 360, clockwise: true)
//        
//        let pathLayer = CAShapeLayer()
//        pathLayer.strokeColor = UIColor.blackColor().CGColor
//        pathLayer.lineWidth = 1
//        pathLayer.fillColor = UIColor.clearColor().CGColor
//        
//        pathLayer.path = arc.CGPath
//        pathLayer.lineDashPattern = [20, 15]
//        
//        view.layer.addSublayer(pathLayer)
    }
    
    var owlsAdded = [UIView]()
    
    func nestClicked() {
        removeNestOwls()
        
        let newBornOwl = addOwlToNest()
        owlsAdded.append(newBornOwl)
        
        let nestRectFromView = nest.convertRect(nest.frame, fromView: view)
        let destinationPointFromCenter = destPointFrom(nestRectFromView.center, iteration: 0)
        
        UIView.animateWithDuration(
            1.0,
            delay: 0.1,
            usingSpringWithDamping: CGFloat(self.damping),
            initialSpringVelocity: CGFloat(self.initVel),
            options: [],
            animations: {
                newBornOwl.center = destinationPointFromCenter
            },
            completion: { _ in
                let f = newBornOwl.convertRect(self.nest.frame, toView: self.nest)
                
//                let v = UIView(frame: f)
//                v.convertPoint(v.center, toView: self.view)
//                v.backgroundColor = UIColor.redColor()
//                self.view.addSubview(v)
//                p(newBornOwl.center)
//                for (var i = 1; i < self.numberOfOwls; i++) {
                var totalDelay = 0.0
                for (var i = 0; i < self.numberOfOwls - 1; i++) {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                    let iv = UIImageView(frame: CGRectMake(f.center.x, f.center.y, 60, 60))
                    iv.image = UIImage(named: "Owl1.png")
                    self.view.addSubview(iv)
                    self.owlsAdded.append(iv)
                    
                    let path = UIBezierPath()
                    
                    let startAngle = CGFloat(i * 45).degreesToRads
                    let endAngle = startAngle + CGFloat(45).degreesToRads
                    path.addArcWithCenter(self.view.center, radius: 100, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                    
                    let speed = 0.5
                    let delayAfterEachBall = 0.05
                    let lambda = Double(i) * delayAfterEachBall
                    let duration: NSTimeInterval = speed - lambda
                    let delay: NSTimeInterval = totalDelay
                    totalDelay = delay + duration
                    
                    let anim = CAKeyframeAnimation(keyPath: "position")
                    anim.beginTime = CACurrentMediaTime() + delay
                    anim.rotationMode = kCAAnimationPaced
                    anim.fillMode = kCAFillModeForwards
                    anim.removedOnCompletion = false
                    anim.duration = duration
                    
                    anim.path = path.CGPath
                    
                    iv.layer.addAnimation(anim, forKey: "circle")
                }
            }
        )
    }
    
    func destPointFrom(center: CGPoint, iteration: Int) -> CGPoint {
        let radius = Float(100)
        let sides = numberOfOwls
        let angle = Float(CGFloat(360 / CGFloat(sides)).degreesToRads)
        let circleAngle = Float(CGFloat(360).degreesToRads)
        let angleDelta = circleAngle - angle * Float(iteration)
        let x = Float(center.x) + radius * cos(angleDelta)
        let y = Float(center.y) + radius * sin(angleDelta)
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    func removeNestOwls() {
        for v in nest.subviews {
            v.removeFromSuperview()
        }
        for v in owlsAdded {
            v.removeFromSuperview()
        }
        owlsAdded = []
    }
    
    func addOwlToNest() -> UIView {
        let nestRectFromView = nest.convertRect(nest.frame, fromView: view)
        let owlRect = CGRectInset(nestRectFromView, 20, 20)
        
        let iv = UIImageView(frame: owlRect)
        iv.image = UIImage(named: "Owl1.png")
        nest.addSubview(iv)
        return iv
    }
}
