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
    var originalBreakCount: Int?
    var workCount: Int?
    var focus: String?
    var pomodoroActive = false
    
    let helper = Helper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // additional setup
        helper.setPlaceholderFont(resultTextField, string: Strings.EnterResultPrompt.rawValue, bold: false)
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
        helper.setWhiteCaret(self)
    }
    
    func setWorkDetails(focus: String, workCount: Int) {
        self.focus = focus
        self.workCount = workCount
        print("Focus: \(focus) and work count: \(workCount)")
        
        workDuration.stringValue = helper.toTimeString(workCount)
        focusText.stringValue = focus
        
    }
}