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
            genericFrame.origin.x = CGFloat(arc4random_uniform(UInt32(confettiView.frame.width)))
            genericFrame.origin.y = CGFloat(arc4random_uniform(UInt32(confettiView.frame.height)))
            confetti = NSImageView(frame: genericFrame)
            confetti!.image = NSImage(named: confettiNames[Int(arc4random_uniform(UInt32(confettiNames.count)))])
            confetti!.frame = genericFrame
            print(confetti!.image)
            print(confetti!.frame)
            confettiView.addSubview(confetti!)
        }
    }
}