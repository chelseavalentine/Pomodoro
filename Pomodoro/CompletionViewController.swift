//
//  CompletionViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/4/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class CompletionViewController: NSViewController {
    let helper = Helper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateConfetti()
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
    }
    
    func generateConfetti() {
        let NUM_STARS = 24
        var confetti: NSImageView?
        var confettiNames: [String] = ["blueConfetti", "greenConfetti", "yellowConfetti"]
        var genericFrame = NSRect(x: 0, y: 0, width: 8, height: 8)
        
        for _ in 1...NUM_STARS {
            genericFrame.origin.x = CGFloat(random()) * CGFloat(self.view.frame.width)
            genericFrame.origin.y = CGFloat(random()) * CGFloat(self.view.frame.width)
            confetti = NSImageView(frame: genericFrame)
            // Int(random() * confettiNames.count)
            confetti!.image = NSImage(named: confettiNames[0])
            self.view.addSubview(confetti!)
        }
    }
}