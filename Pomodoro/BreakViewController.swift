//
//  BreakViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/4/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Foundation
import Cocoa

class BreakViewController: NSViewController, PomodoroScreenProtocol {
    
    @IBOutlet weak var sessionTitle: NSTextField!
    @IBOutlet weak var workProgressBar: NSBox!
    @IBOutlet weak var breakProgressBar: NSBox!
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var startButton: NSImageView!

    var pomodoroTimer: PomodoroTimer?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Initialize style
        StyleHelper.setGeneralStyles(self)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Load data
        let context = DataManager.getContext()!
        let mode = context.modeRelationship
        let session = context.sessionRelationship
        
        let totalCount = mode.breakCount as Int
        
        timeTextField.stringValue = TimeHelper.toTimeString(context.count as Int)
        sessionTitle.stringValue = Strings.BreakSessionTitle.rawValue + " " + String(session.num)
        
        // Initialize pomodoro timer
        pomodoroTimer = PomodoroTimer(view: self, textField: timeTextField, currentCount: context.count as Int, totalCount: totalCount)
        pomodoroTimer?.start()
        
        // Initialize start button
        let startGesture = Helper.makeLeftClickGesture(self)
        startGesture.action = #selector(BreakViewController.startPomodoro)
        startButton.addGestureRecognizer(startGesture)
        
        // Set up progress bar
        initProgressBars()
    }
    
    override func viewWillDisappear() {
        if pomodoroTimer == nil {
            return
        }
        
        let currentCount = pomodoroTimer?.count()
        
        if currentCount != 0 {
            let context = DataManager.getContext()!
            context.count = currentCount!
            DataManager.saveManagedContext()
        }
        
        pomodoroTimer = nil
    }
    
    private func initProgressBars() {
        let context = DataManager.getContext()!
        let mode = context.modeRelationship
        
        let workCount = mode.workCount as Int
        let breakCount = mode.breakCount as Int
        
        let totalCycleCount = CGFloat(breakCount + workCount)
        let workPercentage: Double = Double(workCount) / Double(totalCycleCount)
        
        // Update work progress bar
        ViewHelper.updateProgressBar(self, bar: workProgressBar, percentage: workPercentage, startX: 0)
        
        // Update break progress bar
        ViewHelper.updateProgressBar(self, bar: breakProgressBar, percentage: 0, startX: workProgressBar.frame.width)
    }
    
    func setRunningMode() {
        startButton.image = NSImage(named: "pauseIcon")
    }
    
    func setPausedMode() {
        startButton.image = NSImage(named: "playIcon")
    }
    
    func setStoppedMode() {
        let context = DataManager.getContext()!
        let mode = context.modeRelationship
        let session = context.sessionRelationship
        
        // Clean up this mode
        context.isBreak = false
        context.count = mode.workCount
        
        // Clean up this session
        session.ended = NSDate()
        
        // End session, create a new one
        let newSessionNum = session.num as Int + 1
        
        let newSession = DataManager.createSession(mode, num: newSessionNum)
        context.sessionRelationship = newSession
        DataManager.saveManagedContext()
        
        goToCompletionViewController()
    }
    
    func updateProgressBar(percentage: Double) {
        ViewHelper.updateProgressBar(self, bar: breakProgressBar, percentage: percentage, startX: workProgressBar.frame.width)
    }

    func isBreakView() -> Bool {
        return true
    }
        
    private func goToCompletionViewController() {
        let nextViewController = self.storyboard?.instantiateControllerWithIdentifier(ViewControllerName.Complete.rawValue) as? CompletionViewController
        self.view.window?.contentViewController = nextViewController
    }
    
    @objc private func startPomodoro() {
        pomodoroTimer?.start()
    }
}