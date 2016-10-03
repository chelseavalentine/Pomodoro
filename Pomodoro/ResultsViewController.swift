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
    
    let breakCount = 1
    var workPercentage: CGFloat?
    var workCount: Int?
    
    let helper = Helper.sharedInstance
    
//    var context = [ContextEntity]()
    
    override func viewWillAppear() {
        // Do data stuff here
    }
    
    override func viewDidAppear() {
        // additional setup
        helper.setPlaceholderFont(resultTextField, string: Strings.EnterResultPrompt.rawValue, bold: false)
        helper.updateProgressBar(self, bar: workProgressBar, percentage: CGFloat(0.33333))
        
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
        
        
        // Set context count to break count
        let context = DataManager.getContext()!
        context.count = context.modeRelationship.breakCount
        DataManager.saveManagedContext()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
        helper.setWhiteCaret(self)
    }
    
    func setWorkDetails(focus: String, workCount: Int) {
        workDuration.stringValue = helper.toTimeString(workCount)
        focusText.stringValue = focus
        self.workCount = workCount
        workPercentage = CGFloat(workCount) / CGFloat(workCount + breakCount)
        helper.updateProgressBar(self, bar: workProgressBar, percentage: workPercentage!)
    }
    
    override func keyUp(theEvent: NSEvent) {
        if (resultTextField.stringValue != "") {
            breakIcon.image = NSImage(named: "yellowResumeIcon")
            breakText.textColor = NSColor(red: 255, green: 234, blue: 64, alpha: 1.0)
        } else {
            breakIcon.image = NSImage(named: "whiteResumeIcon")
            breakText.textColor = NSColor(white: 1.0, alpha: 0.65)
        }
        
        if (theEvent.keyCode == 36) {
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
            
            let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("BreakViewController") as? BreakViewController
            self.view.window?.contentViewController = nextViewController
            nextViewController?.setWorkDetails(workCount!)
        }
    }
}