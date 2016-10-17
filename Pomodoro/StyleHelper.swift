//
//  StyleHelper.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 10/17/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class StyleHelper {
    private init() {
    }
    
    static func setGeneralStyles(vc: NSViewController) {
        // Set window background
        vc.view.window?.backgroundColor = NSColor.init(red: 32/255, green: 34/255, blue: 38/255, alpha: 1.0)
        
        // Set white caret
        let fieldEditor = vc.view.window?.fieldEditor(true, forObject: vc) as? NSTextView
        fieldEditor?.insertionPointColor = NSColor.whiteColor()
    }
    
    static func setPlaceholder(textField: NSTextField, string: String, bold: Bool) {
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
}