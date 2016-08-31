//
//  ViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 8/28/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var count: Int = 45 * 60;
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var focusTextField: NSTextField!
    @IBOutlet weak var startButton: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Listen for the keyup event
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUpMask) { (aEvent) -> NSEvent! in
            self.keyUp(aEvent)
            return aEvent
        }
        
        // Initialize start button
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x1 // left mouse
        gesture.target = self
        gesture.action = #selector(ViewController.startPomodoro)
        startButton.addGestureRecognizer(gesture)
        
        // Initialize time text field with time
        var _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        if (count > 0) {
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
            
            timeTextField.stringValue = minutesString + ":" + secondsString
            count -= 1
            
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
        // Return was pressed
        if (theEvent.keyCode == 36) {
            if (focusTextField!.stringValue == "") {
                print("Shit's empty")
            } else {
                startPomodoro()
            }
            
            print(focusTextField!.stringValue)
        }
    }
    
    func start(sender: NSGestureRecognizer) {
        print("Ok starting")
    }
    
    func startPomodoro() {
        print("Ok starting")
    }
}

