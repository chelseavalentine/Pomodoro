//
//  ViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 8/28/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var focusTextField: NSTextField!
    @IBOutlet weak var startButton: NSImageView!
    @IBOutlet weak var progressBar: NSBox!
    
    var originalCount: Int = 1 * 60
    var count: Int = 1 * 60
    var pomodoroActive: Bool = false
    var timer: NSTimer?
    
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
    }
    
    func updateTimer() {
        if (count > 0) {
            count -= 1
            
            // Update the time
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
            
            // Update the progress bar
            var updatedProgress: NSRect = progressBar.frame
            updatedProgress.size.width = 2.0
            updatedProgress.size.width = self.view.frame.width - self.view.frame.width * (CGFloat(count) / CGFloat(originalCount))
            progressBar.frame = updatedProgress
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
                let placeholderTextColor = NSColor(red: 255, green: 255, blue: 255, alpha: 1.0)
                let placeholderFont: NSFont? = NSFont(name: "PT Mono Bold", size: 12)
                let placeholderAttributes: [String: AnyObject] = [
                    NSForegroundColorAttributeName: placeholderTextColor,
                    NSFontAttributeName: placeholderFont!
                ]
                let placeholderAttributedString = NSAttributedString(string: "What are you going to do?", attributes: placeholderAttributes)
                focusTextField.placeholderAttributedString = placeholderAttributedString
            } else {
                startPomodoro()
                focusTextField.enabled = false
            }
        } else if (focusTextField!.stringValue == "") {
            print("we're in")
            let placeholderTextColor2 = NSColor(red: 255, green: 255, blue: 255, alpha: 0.65)
            let placeholderFont2: NSFont? = NSFont(name: "PT Mono", size: 12)
            let placeholderAttributes2: [String: AnyObject] = [
                NSForegroundColorAttributeName: placeholderTextColor2,
                NSFontAttributeName: placeholderFont2!
            ]
            let placeholderAttributedString2 = NSAttributedString(string: "What are you going to do?", attributes: placeholderAttributes2)
            focusTextField.placeholderAttributedString = placeholderAttributedString2
        }
    
    }
    
    func startPomodoro() {
        if (!pomodoroActive) {
            startTimer()
        } else {
            // Todo: find a better way to protect against multiple starts
            // Start the timer again
            if (startButton.image == NSImage(named: "pauseIcon") && timer != nil && count % 60 != 0) {
                stopTimer()
                startButton.image = NSImage(named: "playIcon")
            }
        }
    }
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        pomodoroActive = true
        startButton.image = NSImage(named: "pauseIcon")
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        pomodoroActive = false
        startButton.image = NSImage(named: "playIcon")
    }
}

