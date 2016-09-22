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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
        helper.setWhiteCaret(self)
    }
}