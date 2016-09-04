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
    
    @IBOutlet weak var test: NSBox!
    let breakCount = 6
    var workPercentage: CGFloat?
    
    let helper = Helper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // additional setup
        helper.setPlaceholderFont(resultTextField, string: Strings.EnterResultPrompt.rawValue, bold: false)
        helper.updateProgressBar(self, bar: test, percentage: CGFloat(0.33333))
        
        // Listen for the keyup event
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUpMask) { (aEvent) -> NSEvent! in
            self.keyUp(aEvent)
            return aEvent
        }
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
        helper.setWhiteCaret(self)
    }
    
    func setWorkDetails(focus: String, workCount: Int) {
        workDuration.stringValue = helper.toTimeString(workCount)
        focusText.stringValue = focus
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
            validateResultsField()
        } else {
            helper.setPlaceholderFont(resultTextField, string: Strings.EnterResultPrompt.rawValue, bold: false)
        }
    }
    
    func validateResultsField() {
        if (resultTextField.stringValue == "") {
            helper.setPlaceholderFont(resultTextField, string: Strings.EnterResultPrompt.rawValue, bold: true)
        } else {
            resultTextField.enabled = false
        }
    }
}