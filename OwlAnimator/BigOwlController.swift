//
//  BigOwlController.swift
//  OwlAnimator
//
//  Created by Nuno Gonçalves on 15/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import AVFoundation

class BigOwlController: UIViewController {

    @IBOutlet weak var bigOwlImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var horizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var branchTopConstraint: NSLayoutConstraint!
    
    @IBAction func closeClicked() {
        dismissViewControllerAnimated(false, completion: { _ in
            self.finshedDelegate?.viewWillReappear()
        })
    }
    
    var owlSound: AVAudioPlayer?
    
    var finshedDelegate: FinishedProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        horizontalConstraint.constant = -view.frame.width / 2 - label.frame.width
        branchTopConstraint.constant = -view.frame.height / 2
        buildOwlSound()
    }
    
    override func viewDidAppear(animated: Bool) {
        owlSound!.play()
        
        self.horizontalConstraint.constant = 0.0
        self.branchTopConstraint.constant = 45
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func buildOwlSound() {
        let path = NSBundle.mainBundle().pathForResource("owl_sound", ofType: "mp3")
        let url = NSURL.fileURLWithPath(path!)
        owlSound = try! AVAudioPlayer(contentsOfURL: url)
    }
    
}
