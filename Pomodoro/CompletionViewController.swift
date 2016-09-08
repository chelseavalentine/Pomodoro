//
//  CompletionViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/4/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class CompletionViewController: NSViewController {
    @IBOutlet weak var confettiView: NSView!
    let helper = Helper.sharedInstance
    var endTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateConfetti()
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
    }
    
    func generateConfetti() {
        let NUM_STARS = 36
        var confetti: NSImageView?
        var confettiNames: [String] = ["blueConfetti", "greenConfetti", "yellowConfetti"]
        var genericFrame = NSRect(x: 0, y: 0, width: 8, height: 8)
        
        for _ in 1...NUM_STARS {
            genericFrame.origin.x = CGFloat(arc4random_uniform(UInt32(confettiView.frame.width)))
            genericFrame.origin.y = CGFloat(arc4random_uniform(UInt32(confettiView.frame.height)))
            confetti = NSImageView(frame: genericFrame)
            confetti!.image = NSImage(named: confettiNames[Int(arc4random_uniform(UInt32(confettiNames.count)))])
            confetti!.frame = genericFrame
            confettiView.addSubview(confetti!)
        
            NSTimer.scheduledTimerWithTimeInterval(0.0000001, target: self, selector: #selector(CompletionViewController.floatDown), userInfo: confetti, repeats: true)
        }
        
        endTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(CompletionViewController.endAnimation), userInfo: nil, repeats: true)
    }
    
    func floatDown(timer: NSTimer) {
        let image: NSImageView = timer.userInfo as! NSImageView
        
        if (image.frame.origin.y >  0 - image.frame.height) {
//            if (arc4random_uniform(10) == 0) {
//                image.frame.origin.x += CGFloat(-3 + Int(arc4random_uniform(6)))
//            } else {
//            image.frame.origin.y -= CGFloat(arc4random_uniform(20))
            image.frame.origin.y -= 20
//            }
        } else {
            image.removeFromSuperview()
            timer.invalidate()
        }
    }
    
    func endAnimation(timer: NSTimer) {
        timer.invalidate()
        
        let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("ResultsViewController") as? ResultsViewController
        self.view.window?.contentViewController = nextViewController
    }
}