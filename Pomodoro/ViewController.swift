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
    
    var originalCount: Int = 1
    var count: Int = 1
    var pomodoroActive: Bool = false
    var timer: NSTimer?
    let helper = Helper.sharedInstance
    
    override func viewWillAppear() {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let contextEntity = NSEntityDescription.entityForName("ContextEntity", inManagedObjectContext: managedContext)
//        let cycleEntity = NSEntityDescription.entityForName("CycleEntity", inManagedObjectContext: managedContext)
//        let sessionEntity = NSEntityDescription.entityForName("SessionEntity", inManagedObjectContext: managedContext)
        
        let currContext = ContextEntity(entity: contextEntity!, insertIntoManagedObjectContext: managedContext)
        currContext.count = 1
        
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Couldn't save our context. \(error), \(error.userInfo). :(")
//        }
        
        // Get the data we just saved
        let fetchRequest = NSFetchRequest(entityName: "ContextEntity")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            print(results)
        } catch let error as NSError {
            print("Couldn't fetch...\(error), \(error.userInfo)")
        }
    }
    
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
        gesture.action = #selector(ViewController.validateFocusField)
        startButton.addGestureRecognizer(gesture)
        
        let settingsGesture = NSClickGestureRecognizer()
        settingsGesture.buttonMask = 0x1
        settingsGesture.target = self
        settingsGesture.action = #selector(ViewController.goToSettings)
        settingsButton.addGestureRecognizer(settingsGesture)
        
        timeTextField.stringValue = helper.toTimeString(originalCount)
    }
    
    func goToSettings() {
        // Save state
        // Go to settings
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

    override var representedObject: AnyObject? {
        didSet {
            
        // Update the view, if already loaded.
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

