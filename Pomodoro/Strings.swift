//
//  Strings.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/1/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Foundation

enum Strings: String {
    case EnterFocusPrompt = "What are you going to do?"
    case EnterResultPrompt = "What did you end up doing?"
    
    case FirstModeTitle = "Light mode"
    case SecondModeTitle = "Normal mode"
    case ThirdModeTitle = "Beast mode"
    
    case WorkSessionTitle = "Work session"
    case BreakSessionTitle = "Break"
    
    case TimePlaceholder = "0:00:00"
    
    case Unselected = "SELECT"
    case Selected = "SELECTED"
}

enum DefaultModeName: String {
    case Light = "Light mode"
    case Normal = "Normal mode"
    case Beast = "Beast mode"
}

enum IconName: String {
    case Pause = "pauseIcon"
    case Start = "playIcon"
}

enum ViewControllerName: String {
    case Main = "ViewController"
    case Results = "ResultsViewController"
    case Break = "BreakViewController"
    case Complete = "CompletionViewController"
}