//
//  CompletionViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/4/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class CompletionViewController: NSViewController {
    let helper = Helper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        helper.setWindowBackground(self)
    }
}