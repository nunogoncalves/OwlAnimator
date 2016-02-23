//
//  TableFooterAnimatorController.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 26/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

func P(x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

class TableFooterAnimatorController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var ball: UIView!
    @IBOutlet weak var footer: UIView!
    
    @IBOutlet weak var ballTrailing: NSLayoutConstraint!

    let colors = [
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
        UIColor.grayColor(),
    ]
    
    var rightConstraintConstant: CGFloat!
    var footerVisible = false
    
    var circleDown: UIBezierPath!
    var circleUp1: UIBezierPath!
    var circleUp2: UIBezierPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ball.layer.shadowColor = UIColor.blackColor().CGColor
        
        footer = table.tableFooterView!
        
        ball.setNeedsLayout()
        ball.layoutIfNeeded()
        
        buildCirclePaths()
    }
    
    private func buildCirclePaths() {
        let restAngle = radsFrom(0)
        let downAngle = radsFrom(150)
        let bounceAngle = radsFrom(-10)
        circleDown = arc(startAngle: restAngle, endAngle: downAngle, clockwise: true)
//        drawLinePath(circleDown, UIColor.blackColor())
        
        circleUp1 = arc(startAngle: downAngle, endAngle: bounceAngle, clockwise: false)
//        drawLinePath(circleUp1, UIColor.blackColor())
        
        circleUp2 = arc(startAngle: bounceAngle, endAngle: restAngle, clockwise: true)
//        drawLinePath(circleUp2, UIColor.redColor())
    }
    
    lazy var radius: CGFloat = {
        let mw = self.view.frame.width
        let cr = self.ball.frame.width / 2
        let ts = self.ballTrailing.constant
        
        return (((3 * mw) - (8 * ts) - (8 * cr)) / 4) / 2
    }()
    
    lazy var center: CGPoint = {
        return P(self.ball.center.x - self.radius, self.ball.center.y - 49)
    }()
    
    private func arc(startAngle startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> UIBezierPath {
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }
    
    private func drawLinePath(path: UIBezierPath, _ color: UIColor) {
        let pathLayer = CAShapeLayer()
        pathLayer.strokeColor = color.CGColor
        pathLayer.lineWidth = 1
        pathLayer.fillColor = UIColor.clearColor().CGColor
        pathLayer.path = path.CGPath
        view.layer.addSublayer(pathLayer)
    }
    
}

extension TableFooterAnimatorController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.backgroundColor = colors[indexPath.row]
        cell.textLabel!.text = "\(indexPath.row))"
        
        return cell
    }
    
}

extension TableFooterAnimatorController : UITableViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if isFooterVisible(scrollView) {
            if !footerVisible {
                moveBallDown()
                footerVisible = true
            }
        } else {
            if footerVisible {
                moveBallUp()
                footerVisible = false
            }
        }
    }
    
    private func moveBallDown() {
        animate(inPath: circleDown, duration: 0.3)
        UIView.animateWithDuration(0.3) { [weak self] in
            self?.footer.alpha = 1.0
            self?.ball.alpha = 0.0
            self?.ball.transform = CGAffineTransformMakeScale(0.2, 0.2)
        }
    }
    
    private func moveBallUp() {
        let firstDuration: NSTimeInterval = 0.2
        let secondDuration: NSTimeInterval = 0.1
        animate(inPath: circleUp1, duration: firstDuration)
        animateUpStep2(secondDuration, delay: firstDuration)
        UIView.animateWithDuration(firstDuration) { [weak self] in
            self?.footer?.alpha = 0.0
            self?.ball.alpha = 1.0
            self?.ball.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
    
    private func animate(inPath path: UIBezierPath, duration: NSTimeInterval = 0.5) {
        let anim = animation(duration: duration)
        anim.path = path.CGPath
        ball.layer.addAnimation(anim, forKey: "circle")
    }
    
    private func animateUpStep2(duration: NSTimeInterval, delay: NSTimeInterval) {
        let anim = animation(duration: duration)
        anim.beginTime = CACurrentMediaTime() + delay
        //        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.path = circleUp2.CGPath
        ball.layer.addAnimation(anim, forKey: "circle2")
    }
    
    //https://www.cocoanetics.com/2012/06/lets-bounce/
    private func animation(duration duration: NSTimeInterval = 0.5) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        //        anim.rotationMode = kCAAnimationRotateAuto
        anim.removedOnCompletion = false
        anim.duration = duration
        
        //        return jumpAnimation()
        return anim
    }
    
    private func isFooterVisible(scrollView: UIScrollView) -> Bool {
        let height = scrollView.frame.height
        let offset = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        let footerHeight: CGFloat = footer.frame.height / 2
        
        return (contentSize - height - offset) <= footerHeight
    }
    
}

extension UIView {
    
    func animateLayoutIfNeeded(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
}

func radsFrom(α: CGFloat) -> CGFloat {
    let π: CGFloat = 3.1415
    return α * π / 180
}

func jumpAnimation() -> CAKeyframeAnimation {
    // these three values are subject to experimentation
    let initialMomentum: CGFloat = 300.0 // positive is upwards, per sec
    let gravityConstant: CGFloat = 250.0 // downwards pull per sec
    let dampeningFactorPerBounce: CGFloat = 0.6  // percent of rebound
    
    // internal values for the calculation
    var momentum: CGFloat = initialMomentum // momentum starts with initial value
    var positionOffset: CGFloat  = 0 // we begin at the original position
    let slicesPerSecond: CGFloat = 60.0 // how many values per second to calculate
    let lowerMomentumCutoff: CGFloat = 5.0 // below this upward momentum animation ends
    
    var duration: CGFloat = 0
    var values: [NSValue] = []
    repeat {
        duration += CGFloat(1.0 / slicesPerSecond)
        positionOffset += momentum / slicesPerSecond
        
        if (positionOffset < 0) {
            positionOffset = 0
            momentum = -momentum * dampeningFactorPerBounce
        }
        
        // gravity pulls the momentum down
        momentum -= gravityConstant / slicesPerSecond;
        
        let transform = CATransform3DMakeTranslation(0, -positionOffset, 0);
        values.append(NSValue(CATransform3D: transform))
        //        values addObject:[NSValue valueWithCATransform3D:transform]];
    } while (!(positionOffset == 0 && momentum < lowerMomentumCutoff));
    
    let animation = CAKeyframeAnimation(keyPath: "position")
    animation.repeatCount = 1;
    animation.duration = CFTimeInterval(duration)
    animation.fillMode = kCAFillModeForwards
    animation.values = values
    animation.removedOnCompletion = true // final stage is equal to starting stage
    animation.autoreverses = false
    
    return animation
}
