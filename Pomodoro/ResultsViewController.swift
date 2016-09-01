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
    var breakCount: Int?
    var originalBreakCount: Int?
    var pomodoroActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // additional setup
    }
    
    override func awakeFromNib() {
        self.view.window?.backgroundColor = NSColor.init(red: 32/255, green: 34/255, blue: 38/255, alpha: 1.0)
    }
}