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
    @IBOutlet weak var settingsButton: NSImageView!
    
    var originalCount: Int = 900
    var count: Int = 900
    var pomodoroActive: Bool = false
    var timer: NSTimer?
    let helper = Helper.sharedInstance
    
    override func viewWillAppear() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Listen for the keyup event
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyUpMask) { (aEvent) -> NSEvent! in
            self.keyUp(aEvent)
            return aEvent
        }
        
        initButtons()
        loadData()
    }
    
    func initButtons() {
        // Initialize start button
        let gesture = helper.makeLeftClickGesture(self)
        gesture.action = #selector(ViewController.validateFocusField)
        startButton.addGestureRecognizer(gesture)
        
        let settingsGesture = helper.makeLeftClickGesture(self)
        settingsGesture.action = #selector(ViewController.goToSettings)
        settingsButton.addGestureRecognizer(settingsGesture)
    }
    
    func loadData() {
        var cycle = DataManager.getContext()?.cycleRelationship
        
        if cycle != nil {
            originalCount = cycle!.workCount! as Int
        }
        
        count = originalCount
        timeTextField.stringValue = helper.toTimeString(originalCount)
    }
    
    func goToSettings() {
        // TODO: Save state
        
        helper.goToSettings(self)
    }
    
    func updateTimer() {
        if (count > 0) {
            // Update the time
            count -= 1
            timeTextField.stringValue = helper.toTimeString(count)
            
            // Update the progress bar
            helper.updateProgressBar(self, bar: progressBar, percentage: CGFloat(count) / CGFloat(originalCount))
        } else {
            stopTimer()
            let nextViewController = self.storyboard?.instantiateControllerWithIdentifier("ResultsViewController") as? ResultsViewController
            self.view.window?.contentViewController = nextViewController
            nextViewController?.setWorkDetails(focusTextField.stringValue, workCount: originalCount)
        }
    }

    override func awakeFromNib() {
        helper.setWindowBackground(self)
        helper.setWhiteCaret(self)
        
        focusTextField.textColor = NSColor.whiteColor()
        
        // Set TextField font and color
        helper.setPlaceholderFont(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: false)
    }

    override func keyUp(theEvent: NSEvent) {
        // Return was pressed
        if (theEvent.keyCode == 36) {
            validateFocusField()
        } else if (focusTextField!.stringValue == "") {
            helper.setPlaceholderFont(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: false)
        }
    }
    
    func validateFocusField() {
        if (focusTextField!.stringValue == "") {
            helper.setPlaceholderFont(focusTextField, string: Strings.EnterFocusPrompt.rawValue, bold: true)
        } else {
            startPomodoro()
            focusTextField.enabled = false
            
            // Save goal
            let context = DataManager.getContext()
            context!.sessionRelationship!.goal = focusTextField!.stringValue
            DataManager.saveManagedContext()
        }
    }
    
    func startPomodoro() {
        if (!pomodoroActive) {
            startTimer()
            
            // First time starting this session
            let session = DataManager.getContext()!.sessionRelationship!
            session.started = NSDate()
            DataManager.saveManagedContext()
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
        
        // Save paused
        let context = DataManager.getContext()!
        context.sessionRelationship!.numPausedTimes = (context.sessionRelationship!.numPausedTimes! as Int + 1) as NSNumber
        context.count = count
        DataManager.saveManagedContext()
    }
}

