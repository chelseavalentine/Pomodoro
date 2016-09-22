//
//  BreakViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/4/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Foundation
import Cocoa

class BreakViewController: NSViewController {
    @IBOutlet weak var workProgressBar: NSBox!
    @IBOutlet weak var breakProgressBar: NSBox!
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var startButton: NSImageView!
    @IBOutlet weak var settingsButton: NSImageView!
    
    var originalCount = 1
    var count = 1
    var pomodoroActive = false
    var timer: NSTimer?
    let helper = Helper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize start button
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x1 // left mouse
        gesture.target = self
        gesture.action = #selector(BreakViewController.startPomodoro)
        startButton.addGestureRecognizer(gesture)
        
        timeTextField.stringValue = helper.toTimeString(originalCount)
        startPomodoro()
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
    }
    
    func initButtons() {
        let startGesture = helper.makeLeftClickGesture(self)
        startGesture.action = #selector(BreakViewController.startPomodoro)
        startButton.addGestureRecognizer(startGesture)
        
        let settingsGesture = helper.makeLeftClickGesture(self)
        settingsGesture.action = #selector(BreakViewController.goToSettings)
        settingsButton.addGestureRecognizer(settingsGesture)
    }
    
    func goToSettings() {
        // TODO: save state
        
        helper.goToSettings(self)
    }
    
    func setWorkDetails(workCount: Int) {
        let workPercentage = CGFloat(workCount) / CGFloat(workCount + originalCount)
        let workProgressWidth = self.view.frame.width - self.view.frame.width * (workPercentage)
        helper.updateProgressBar(self, bar: workProgressBar, percentage: workPercentage)
        var breakProgressFrame: NSRect = breakProgressBar.frame
        breakProgressFrame.size.width = 70.0
        breakProgressFrame.origin.x = workProgressWidth
    }
    
    func startPomodoro() {
        if (!pomodoroActive) {
            startTimer()
        } else {
            // Todo: find a better way to protect against multiple starts
            // Start the timer again
            if (startButton.image == NSImage(named: "pauseIcon") && timer != nil && count % 60 != 0) {
                stopTimer()
                startButton.image = NSImage(named: "playIcon")
            }
        }
    }
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(BreakViewController.updateTimer), userInfo: nil, repeats: true)
        pomodoroActive = true
        startButton.image = NSImage(named: "pauseIcon")
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        pomodoroActive = false
        startButton.image = NSImage(named: "playIcon")
    }
    
    func updateTimer() {
        if (count > 0) {
            // Update the time
            count -= 1
            timeTextField.stringValue = helper.toTimeString(count)
            
            // Update the progress bar
            helper.updateProgressBar(self, bar: breakProgressBar, percentage: CGFloat(count) / CGFloat(originalCount))
        } else {
            stopTimer()
            let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("CompletionViewController") as? CompletionViewController
            self.view.window?.contentViewController = nextViewController
        }
    }
}