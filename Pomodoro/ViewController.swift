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
    
    var totalWorkCount: Int = 6
    var currentCount: Int = 6
    var pomodoroActive: Bool = false
    var timer: NSTimer?
    let helper = Helper.sharedInstance
    var pomodoroTimer: PomodoroTimer?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Load data
        let context = DataManager.getContext()
        let session = context?.sessionRelationship
        let mode = context?.modeRelationship
        
        // Set work conut
        totalWorkCount = mode?.workCount as? Int ?? 1
        
        if context?.isBreak == true && session?.result != nil {
            // User was in a break
            goToBreakViewController()
        } else if context?.isBreak == true && session?.result == nil {
            // User finished work session, but didn't report on what
            // they did
            goToResultsViewController()
        } else if session?.goal != nil {
            // User had paused session
            focusTextField.stringValue = context!.sessionRelationship.goal!
            focusTextField.enabled = false
            
            // Set current counts
            currentCount = context!.count as Int
            totalWorkCount = mode!.workCount as Int
        } else {
            // User didn't have a session
            currentCount = totalWorkCount
            timeTextField.stringValue = helper.toTimeString(totalWorkCount)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialize style
        helper.setWindowBackground(self)
        helper.setWhiteCaret(self)
        
        focusTextField.textColor = NSColor.whiteColor()
        
        // Set TextField font and color
        helper.setPlaceholderFont(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: false)
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
        let gesture = helper.makeLeftClickGesture(self)
        gesture.action = #selector(ViewController.validateFocusField)
        startButton.addGestureRecognizer(gesture)
        
        // Initialize settings button
        let settingsGesture = helper.makeLeftClickGesture(self)
        settingsGesture.action = #selector(ViewController.goToSettings)
        settingsButton.addGestureRecognizer(settingsGesture)
    }
    
    override func keyUp(theEvent: NSEvent) {
        // Return was pressed
        if (theEvent.keyCode == Keys.ReturnKey.rawValue) {
            validateFocusField()
        } else if (focusTextField!.stringValue == "") {
            helper.setPlaceholderFont(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: false)
        }
    }
    
    func validateFocusField() {
        if (focusTextField.stringValue == "") {
            // Emphasize the focus field
            helper.setPlaceholderFont(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: true)
        } else {
            pomodoroTimer = PomodoroTimer(view: self, textField: timeTextField, currentCount: currentCount, totalCount: totalWorkCount)
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
        // Save state
        let context = DataManager.getContext()
        
        // Indicate break mode if complete, or just save state
        if totalWorkCount == currentCount {
            context?.count = 0
            context?.isBreak = true
        } else {
            context?.count = currentCount
        }
        
        DataManager.saveManagedContext()
    }
    
    func setRunningMode() {
        startButton.image = NSImage(named: "pauseIcon")
    }
    
    func setPausedMode() {
        startButton.image = NSImage(named: "playIcon")
    }
    
    func updateProgressBar(percentage: CGFloat) {
        helper.updateProgressBar(self, bar: progressBar, percentage: percentage)
    }
    
    func setStoppedMode() {
        goToResultsViewController()
    }
    
    func isBreakView() -> Bool {
        return false
    }
    
    func goToSettings() {
        helper.goToSettings(self)
    }
    
    private func goToResultsViewController() {
        let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("ResultsViewController") as? ResultsViewController
        self.view.window?.contentViewController = nextViewController
    }
    
    private func goToBreakViewController() {
        let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("BreakViewController") as? BreakViewController
        self.view.window?.contentViewController = nextViewController
    }
}

