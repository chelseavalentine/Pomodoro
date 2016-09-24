//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/22/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    let helper = Helper.sharedInstance
    
    @IBOutlet weak var firstEditButton: NSImageView!
    @IBOutlet weak var firstModeTitle: NSTextField!
    @IBOutlet weak var firstWorkTime: NSTextField!
    @IBOutlet weak var firstBreakTime: NSTextField!
    
    @IBOutlet weak var secondEditButton: NSImageView!
    @IBOutlet weak var secondModeTitle: NSTextField!
    @IBOutlet weak var secondBreakTime: NSTextField!
    @IBOutlet weak var secondWorkTime: NSTextField!
    
    @IBOutlet weak var thirdEditButton: NSImageView!
    @IBOutlet weak var thirdModeTitle: NSTextField!
    @IBOutlet weak var thirdBreakTime: NSTextField!
    @IBOutlet weak var thirdWorkTime: NSTextField!

    @IBOutlet weak var returnIcon: NSImageView!
    @IBOutlet weak var returnText: NSTextField!
    
    var previousViewController: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationButtons()
        initCycleFields()
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
        helper.setWhiteCaret(self)
        
        initTextFields()
    }
    
    func initTextFields() {
        // Set placeholder colors
        helper.setPlaceholderFont(firstModeTitle, string: Strings.FirstModeTitle.rawValue, bold: false)
        helper.setPlaceholderFont(firstWorkTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        helper.setPlaceholderFont(firstBreakTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        
        helper.setPlaceholderFont(secondModeTitle, string: Strings.SecondModeTitle.rawValue, bold: false)
        helper.setPlaceholderFont(secondWorkTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        helper.setPlaceholderFont(secondBreakTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        
        helper.setPlaceholderFont(thirdModeTitle, string: Strings.ThirdModeTitle.rawValue, bold: false)
        helper.setPlaceholderFont(thirdWorkTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        helper.setPlaceholderFont(thirdBreakTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        
        // Set listeners to format & validate time inputs
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUpMask) {(aEvent) -> NSEvent! in
            self.keyUp(aEvent)
            return aEvent
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        thirdModeTitle.keyUp(<#T##theEvent: NSEvent##NSEvent#>)
    }
    
    func initCycleFields() {
        
    }
    
    func initNavigationButtons() {
        let returnGesture = helper.makeLeftClickGesture(self)
        returnGesture.action = #selector(SettingsViewController.returnToPrevViewController)
        returnIcon.addGestureRecognizer(returnGesture)
        returnText.addGestureRecognizer(returnGesture)
    }
    
    func returnToPrevViewController() {
        helper.returnToPrevViewController(self, destination: previousViewController!)
    }
    
    func formatTimeInput() {
    }
    
    func setPrevViewController(prevVc: String) {
        previousViewController = prevVc
    }
}