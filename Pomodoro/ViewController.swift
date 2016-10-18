//
//  ViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 8/28/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, PomodoroScreenProtocol {
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var focusTextField: NSTextField!
    @IBOutlet weak var startButton: NSImageView!
    @IBOutlet weak var progressBar: NSBox!
    @IBOutlet weak var settingsButton: NSImageView!
    
    var totalWorkCount: Int?
    var currentCount: Int?
    var pomodoroTimer: PomodoroTimer?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Load data
        let context = DataManager.getContext()
        let session = context?.sessionRelationship
        let mode = context?.modeRelationship
        
        // Set work conut
        totalWorkCount = mode?.workCount as? Int ?? DefaultWorkCount.Normal.rawValue
        
        if context?.isBreak == true && session?.result != nil {
            // User was in a break
            goToBreakViewController()
        } else if context?.isBreak == true && session?.result == nil {
            // User finished work session, but didn't report on what
            // they did
            goToResultsViewController()
        } else if context?.count != nil && context?.count as! Int > 0 && session?.goal != nil {
            // Set current counts
            currentCount = context!.count as Int
            totalWorkCount = mode!.workCount as Int
            
            timeTextField.stringValue = TimeHelper.toTimeString(currentCount!)
            
            focusTextField.stringValue = session!.goal!
            focusTextField.enabled = false
            
            settingsButton.hidden = true
        } else if session?.goal != nil {
            if session?.result == nil {
                goToResultsViewController()
            }
            
            // User had paused session OR completed session
            focusTextField.stringValue = session!.goal!
            focusTextField.enabled = false
            
            // Set current counts
            currentCount = context!.count as Int
            totalWorkCount = mode!.workCount as Int
        } else {
            // User didn't have a session
            currentCount = totalWorkCount
            timeTextField.stringValue = TimeHelper.toTimeString(totalWorkCount!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialize style
        StyleHelper.setGeneralStyles(self)
        StyleHelper.setPlaceholder(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: false)
        
        focusTextField.textColor = NSColor.whiteColor()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Init text field by focusing & listening for enter
        focusTextField.lockFocus()
        
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUpMask) { (aEvent) -> NSEvent! in
            self.keyUp(aEvent)
            return aEvent
        }
        
        // Initialize start button
        let gesture = Helper.makeLeftClickGesture(self)
        gesture.action = #selector(ViewController.validateFocusField)
        startButton.addGestureRecognizer(gesture)
        
        // Initialize settings button
        let settingsGesture = Helper.makeLeftClickGesture(self)
        settingsGesture.action = #selector(ViewController.goToSettings)
        settingsButton.addGestureRecognizer(settingsGesture)
    }
    
    override func keyUp(theEvent: NSEvent) {
        // Return was pressed
        if (theEvent.keyCode == Keys.ReturnKey.rawValue) {
            validateFocusField()
        } else if (focusTextField!.stringValue == "") {
            StyleHelper.setPlaceholder(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: false)
        }
    }
    
    func validateFocusField() {
        if (focusTextField.stringValue == "") {
            // Emphasize the focus field
            StyleHelper.setPlaceholder(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: true)
        } else if pomodoroTimer?.isRunning() == true {
            pomodoroTimer?.start()
        } else {
            if totalWorkCount == nil || currentCount == nil {
                return
            }
            
            pomodoroTimer = PomodoroTimer(view: self, textField: timeTextField, currentCount: currentCount!, totalCount: totalWorkCount!)
            pomodoroTimer?.start()
            
            // Disable text editing
            focusTextField.enabled = false
            
            // Save goal
            let context = DataManager.getContext()!
            context.sessionRelationship.goal = focusTextField!.stringValue
            DataManager.saveManagedContext()
        }
    }
    
    override func viewWillDisappear() {
        let context = DataManager.getContext()!
        
        if pomodoroTimer == nil {
            return
        }
        
        currentCount = pomodoroTimer?.count()
        
        // Indicate break mode if timer is complete, or save state
        if currentCount == 0 {
            context.isBreak = true
        } else {
            context.count = currentCount!
        }
        
        DataManager.saveManagedContext()
        
        pomodoroTimer = nil
    }
    
    func setRunningMode() {
        startButton.image = NSImage(named: IconName.Pause.rawValue)
        settingsButton.hidden = true
    }
    
    func setPausedMode() {
        startButton.image = NSImage(named: IconName.Start.rawValue)
    }
    
    func updateProgressBar(percentage: CGFloat) {
        ViewHelper.updateProgressBar(self, bar: progressBar, percentage: percentage, startX: 0)
    }
    
    func setStoppedMode() {
        goToResultsViewController()
    }
    
    func isBreakView() -> Bool {
        return false
    }
    
    func goToSettings() {
        if currentCount > 0 {
            let context = DataManager.getContext()!
            context.count = currentCount!
            DataManager.saveManagedContext()
        }
        
        Helper.goToSettings(self)
    }
    
    private func goToResultsViewController() {
        let nextViewController = self.storyboard?.instantiateControllerWithIdentifier(ViewControllerName.Results.rawValue) as? ResultsViewController
        self.view.window?.contentViewController = nextViewController
    }
    
    private func goToBreakViewController() {
        let nextViewController = self.storyboard?.instantiateControllerWithIdentifier(ViewControllerName.Break.rawValue) as? BreakViewController
        self.view.window?.contentViewController = nextViewController
    }
}

