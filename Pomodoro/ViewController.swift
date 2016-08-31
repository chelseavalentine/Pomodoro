//
//  ViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 8/28/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var focusTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Initialize event listeners
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUpMask) { (aEvent) -> NSEvent! in
            self.keyUp(aEvent)
            return aEvent
        }

    }

    override var representedObject: AnyObject? {
        didSet {
            
        // Update the view, if already loaded.
        }
    }

    override func awakeFromNib() {
        self.view.window?.backgroundColor = NSColor.init(red: 32/255, green: 34/255, blue: 38/255, alpha: 1.0)
    
        focusTextField.textColor = NSColor.whiteColor()
        
        // Set TextField font and color
        let placeholderTextColor = NSColor(red: 255, green: 255, blue: 255, alpha: 0.65)
        let placeholderFont: NSFont? = NSFont(name: "PT Mono", size: 12)
        let placeholderAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: placeholderTextColor,
            NSFontAttributeName: placeholderFont!
        ]
        let placeholderAttributedString = NSAttributedString(string: "What are you going to do?", attributes: placeholderAttributes)
        focusTextField.placeholderAttributedString = placeholderAttributedString
        
        // Make TextField caret white
        let fieldEditor = self.view.window?.fieldEditor(true, forObject: self) as? NSTextView
        fieldEditor?.insertionPointColor = NSColor.whiteColor()
    }

    override func keyUp(theEvent: NSEvent) {
        print("hahaha")
        // Return was pressed
        if (theEvent.keyCode == 36) {
            print("hell yea")
            if (focusTextField!.stringValue == "") {
                print("Shit's empty")
            } else {
                print("Great")
            }
            
            print(focusTextField!.stringValue)
        }
    }
}

