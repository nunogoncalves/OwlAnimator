//
//  CircularAnimationController.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 19/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class CircularAnimationController: UIViewController {
    
    @IBOutlet weak var nest: UIView!
    
    @IBOutlet weak var initVelLabel: UILabel!
    @IBOutlet weak var stiffnessLabel: UILabel!
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var owlsNumLabel: UILabel!
    
    @IBAction func initialVelocityChanged(slider: UISlider) {
        updateValOf(initVelLabel, value: slider.value)
        initVel = slider.value
    }
    
    @IBAction func dampingChanged(slider: UISlider) {
        updateValOf(dampingLabel, value: slider.value)
        damping = slider.value
    }
    
    @IBAction func stiffnessChanged(slider: UISlider) {
        updateValOf(stiffnessLabel, value: slider.value)
        stiffness = slider.value
    }
    
    @IBAction func numOfOwlsChanged(slider: UISlider) {
        slider.setValue(Float(lroundf(slider.value)), animated: true)
        updateValOf(owlsNumLabel, value: slider.value)
        numberOfOwls = Int(slider.value)
    }
    
    private func updateValOf(label: UILabel, value: Float) {
        label.text = NSString(format: "%.3f", value) as String
    }
    
    var damping: Float = 0.46
    var initVel: Float = 0
    var stiffness: Float = 0
    
    var numberOfOwls = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: "owlClicked")
        nest.addGestureRecognizer(tap)
        
    }
    
    func drawArcAroundNest() {
        let arc = UIBezierPath()
        arc.addArcWithCenter(nest.center, radius: 100, startAngle: 0, endAngle: 360, clockwise: true)
        
        let pathLayer = CAShapeLayer()
        pathLayer.strokeColor = UIColor.blackColor().CGColor
        pathLayer.lineWidth = 1
        pathLayer.fillColor = UIColor.clearColor().CGColor
        
        pathLayer.path = arc.CGPath
        pathLayer.lineDashPattern = [20, 15]
        
        view.layer.addSublayer(pathLayer)
    }
    
    var lines = [CALayer]()
    
    func drawLineBetwen(point1: CGPoint, point2: CGPoint) {
        let path = UIBezierPath()
        path.moveToPoint(point1)
        path.addLineToPoint(point2)
        
        let pathLayer = CAShapeLayer()
        pathLayer.strokeColor = UIColor.blackColor().CGColor
        pathLayer.lineWidth = 1
        pathLayer.fillColor = UIColor.clearColor().CGColor
        
        pathLayer.path = path.CGPath
        lines.append(pathLayer)
        view.layer.addSublayer(pathLayer)
        
    }
    
    var clicked = false
    
    func owlClicked() {
        removeNestOwls()
        for (var i = 0; i < numberOfOwls; i++) {
            let newBornOwl = addOwlToNest()
            
            let nestRectFromView = nest.convertRect(nest.frame, fromView: view)
            let destinationPointFromCenter = destPointFrom(nestRectFromView.center, iteration: i)
            
            //            drawLineBetwen(nest.center, point2: view.convertPoint(destinationPointFromCenter, fromView: nest))
            
            //            drawArcAroundNest()
            
            UIView.animateWithDuration(
                1.0,
                delay: NSTimeInterval(CGFloat(i) * CGFloat(0.1)),
                usingSpringWithDamping: CGFloat(self.damping),
                initialSpringVelocity: CGFloat(self.initVel),
                options: [],
                animations: {
                    newBornOwl.center = destinationPointFromCenter
                },
                completion: nil
            )
        }
        clicked = !clicked
    }
    
    func createSpringAnimation() {
        //        let spring = CASpringAnimation(keyPath: "position")
        //        spring.damping = CGFloat(damping)
        //        spring.stiffness = CGFloat(stiffness)
        //        spring.initialVelocity = CGFloat(initVel)
        //        spring.fillMode = kCAFillModeForwards
        //        spring.removedOnCompletion = false
        //        spring.fromValue = NSValue(CGPoint: CGPoint(x: v.center.x + x[i], y: v.center.y - y[i]))
        //        spring.toValue = NSValue(CGPoint: v.center)
        //        spring.duration = spring.settlingDuration
        //        v.layer.addAnimation(spring, forKey: nil)
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
    
    func addOwlToNest() -> UIView {
        let nestRectFromView = nest.convertRect(nest.frame, fromView: view)
        let owlRect = CGRectInset(nestRectFromView, 20, 20)
        
        let iv = UIImageView(frame: owlRect)
        iv.image = UIImage(named: "Owl\(randomUpTo(22) + 1).png")
        nest.addSubview(iv)
        return iv
    }
    
    func removeNestOwls() {
        for v in nest.subviews {
            v.removeFromSuperview()
        }
        for line in lines {
            line.removeFromSuperlayer()
        }
    }
}

func randomUpTo(value: Int) -> Int {
    return Int(arc4random_uniform(UInt32(value)))
}

extension CGFloat {
    var degreesToRads: CGFloat {
        let π = CGFloat(M_PI)
        return self * π / 180
    }
    
    var radsToDegrees: CGFloat {
        let π = CGFloat(M_PI)
        return 180 * self / π
    }
}

func p<T>(item: T) {
    print(item)
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2)
    }
}
