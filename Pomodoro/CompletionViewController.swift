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
    @IBOutlet weak var sessionTitle: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateConfetti()
        
        let gesture = helper.makeLeftClickGesture(self)
        gesture.action = #selector(CompletionViewController.goToFirstView)
        self.view.addGestureRecognizer(gesture)
        
        // Init keyup
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUpMask) { (aEvent) -> NSEvent! in
            self.keyUp(aEvent)
            return aEvent
        }
    }
    
    override func awakeFromNib() {
        StyleHelper.setGeneralStyles(self)
        
        // Subtract 1 because this session num refers to the new session
        let sessionNum = DataManager.getContext()!.sessionRelationship.num
        sessionTitle.stringValue = "Work session \(sessionNum as Int - 1)"
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
        
        endTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(CompletionViewController.goToFirstView), userInfo: nil, repeats: true)
    }
    
    func floatDown(timer: NSTimer) {
        let image: NSImageView = timer.userInfo as! NSImageView
        
        if (image.frame.origin.y >  0 - image.frame.height) {
            image.frame.origin.y -= 20
        } else {
            image.removeFromSuperview()
            timer.invalidate()
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        goToFirstView()
    }
    
    func endAnimation(timer: NSTimer?) {
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    func goToFirstView() {
        endAnimation(endTimer)
        
        let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("ViewController") as? ViewController
        self.view.window?.contentViewController = nextViewController
    }
}