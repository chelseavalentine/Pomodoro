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
    static let sharedInstance = Helper()
    
    private init() {}
    
    func toTimeString(count: Int) -> String {
        let minutes = count / 60;
        let seconds = count - (minutes * 60)
        var minutesString: String;
        var secondsString: String;
        
        if (minutes < 10) {
            minutesString = "0\(minutes)"
        } else {
            minutesString = "\(minutes)"
        }
        
        if (seconds < 10) {
            secondsString = "0\(seconds)"
        } else {
            secondsString = "\(seconds)"
        }
        
        return minutesString + ":" + secondsString
    }
    
    // TODO: Fix me
    func toTimeCount(time: String) -> Int {
        var count = 0
        var exponent = 0;
        var timeComponents = time.characters.split{$0 == ":"}
        
        while timeComponents.count > 0 {
            print(timeComponents.popLast())
            count += 1
            exponent += 1
//            let timeComponent: Int = Int!(timeComponents.popLast())
//            count += pow(timeComponents.popLast(), exponent)
//            exponent += 1
        }
        
        return count;
    }
    
    func setWindowBackground(viewController: NSViewController) {
        viewController.view.window?.backgroundColor = NSColor.init(red: 32/255, green: 34/255, blue: 38/255, alpha: 1.0)
    }
    
    func setPlaceholderFont(textField: NSTextField, string: String, bold: Bool) {
        var font: NSFont?
        var color: NSColor?
        
        if bold {
            color = NSColor.whiteColor()
            font = NSFont(name: "PT Mono Bold", size: 12)
        } else {
            color = NSColor(red: 255, green: 255, blue: 255, alpha: 0.65)
            font = NSFont(name: "PT Mono", size: 12)
        }
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: color!,
            NSFontAttributeName: font!
        ]
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        textField.placeholderAttributedString = attributedString
    }
    
    func setWhiteCaret(viewController: NSViewController) {
        let fieldEditor = viewController.view.window?.fieldEditor(true, forObject: viewController) as? NSTextView
        fieldEditor?.insertionPointColor = NSColor.whiteColor()
    }
    
    func updateProgressBar(vc: NSViewController, bar: NSBox, percentage: CGFloat) {
        var updatedProgress: NSRect = bar.frame
        updatedProgress.size.width = vc.view.frame.width - vc.view.frame.width * (percentage)
        bar.frame = updatedProgress
    }
    
    func goToSettings(vc: ViewController) {
        let nextViewController = vc.storyboard?.instantiateControllerWithIdentifier("SettingsViewController") as? SettingsViewController
        vc.view.window?.contentViewController = nextViewController
        SettingsViewController.className()
    }
}