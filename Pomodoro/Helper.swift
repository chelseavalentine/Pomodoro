//
//  Helper.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/1/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Foundation
import Cocoa

class Helper {
    private init() {}
    
    static func goToSettings(vc: NSViewController) {
        let settingsVC = vc.storyboard?.instantiateControllerWithIdentifier("SettingsViewController") as? SettingsViewController
        vc.view.window?.contentViewController = settingsVC
        settingsVC?.setPrevViewController(vc.className)
    }
    
    static func makeLeftClickGesture(vc: NSViewController) -> NSClickGestureRecognizer {
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x1 // left mouse
        gesture.target = vc
        return gesture;
    }
    
    static func returnToPrevViewController(vc: NSViewController, destination: String) {
        if destination == "Pomodoro.ViewController" {
            let nextViewController = vc.storyboard?.instantiateControllerWithIdentifier("ViewController") as? ViewController
            vc.view.window?.contentViewController = nextViewController
        } else if destination == "Pomodoro.BreakViewController" {
            let nextViewController = vc.storyboard?.instantiateControllerWithIdentifier("BreakViewController") as? BreakViewController
            vc.view.window?.contentViewController = nextViewController
        }
    }
}