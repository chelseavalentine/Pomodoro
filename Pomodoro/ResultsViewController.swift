//
//  ResultsViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/1/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Foundation
import Cocoa

class ResultsViewController: NSViewController {
    
    @IBOutlet weak var workDuration: NSTextField!
    @IBOutlet weak var focusText: NSTextField!
    @IBOutlet weak var breakText: NSTextField!
    @IBOutlet weak var breakIcon: NSImageView!
    @IBOutlet weak var workProgressBar: NSBox!
    @IBOutlet weak var resultTextField: NSTextField!
    
    var breakCount: Int?
    var workCount: Int?
    var timer: NSTimer?
    let helper = Helper.sharedInstance
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Initialize style
        StyleHelper.setGeneralStyles(self)
        StyleHelper.setPlaceholder(resultTextField, string: Strings.EnterResultPrompt.rawValue, bold: false)
        
        // PREPARE FOR BREAK MODE
//        let context = DataManager.getContext()!
//        let mode = context.modeRelationship
//        context.count = mode.breakCount
//        DataManager.saveManagedContext()
        
        // Load data
        let context = DataManager.getContext()!
        let mode = context.modeRelationship
        let session = context.sessionRelationship
        
        focusText.stringValue = session.goal!
        workDuration.stringValue = TimeHelper.toTimeString(mode.workCount as Int)
    }
    
    override func awakeFromNib() {
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: #selector(ResultsViewController.initProgressBar), userInfo: nil, repeats: false)
        
    }
    
    override func viewDidAppear() {
        super.viewDidLoad()
        
        initProgressBar()
        
        // Listen for the keyup event
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUpMask) { (aEvent) -> NSEvent! in
            self.keyUp(aEvent)
            return aEvent
        }
        
        // Initialize start break button
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x1 // left mouse
        gesture.target = self
        gesture.action = #selector(ResultsViewController.validateResultField)
        breakIcon.addGestureRecognizer(gesture)
        breakText.addGestureRecognizer(gesture)
    }
    
    override func viewWillDisappear() {
        // Save state
    }
    
    private func initProgressBar() {
        let mode = DataManager.getContext()!.modeRelationship
        
        workCount = mode.workCount as Int
        breakCount = mode.breakCount as Int
        
        let totalCycleCount = CGFloat(breakCount! + workCount!)
        let workPercentage: CGFloat = (CGFloat(workCount!) / totalCycleCount)
        
        var updatedProgress: NSRect = workProgressBar.frame
        updatedProgress.size.width = self.view.frame.width * workPercentage
        workProgressBar.frame = updatedProgress
        
        timer?.invalidate()
    }
    
    func setWorkDetails(focus: String, workCount: Int) {
        workDuration.stringValue = helper.toTimeString(workCount)
        focusText.stringValue = focus
    }
    
    override func keyUp(theEvent: NSEvent) {
        if (resultTextField.stringValue != "") {
            breakIcon.image = NSImage(named: "yellowResumeIcon")
            breakText.textColor = NSColor(red: 255, green: 234, blue: 64, alpha: 1.0)
        } else {
            breakIcon.image = NSImage(named: "whiteResumeIcon")
            breakText.textColor = NSColor(white: 1.0, alpha: 0.65)
        }
        
        if (theEvent.keyCode == Keys.ReturnKey.rawValue) {
            validateResultField()
        } else {
            helper.setPlaceholderFont(resultTextField, string: Strings.EnterResultPrompt.rawValue, bold: false)
        }
    }
    
    func validateResultField() {
        if (resultTextField.stringValue == "") {
            helper.setPlaceholderFont(resultTextField, string: Strings.EnterResultPrompt.rawValue, bold: true)
        } else {
            resultTextField.enabled = false
            
//            let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("BreakViewController") as? BreakViewController
//            self.view.window?.contentViewController = nextViewController
//            nextViewController?.setWorkDetails(6)
        }
    }
    
    private func goToBreakViewController() {
        let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("BreakViewController") as? BreakViewController
        self.view.window?.contentViewController = nextViewController
    }
}