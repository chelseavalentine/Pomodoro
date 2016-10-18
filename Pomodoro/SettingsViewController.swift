//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/22/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    @IBOutlet weak var firstEditButton: NSImageView!
    @IBOutlet weak var firstModeTitle: NSTextField!
    @IBOutlet weak var firstWorkTime: NSTextField!
    @IBOutlet weak var firstBreakTime: NSTextField!
    @IBOutlet weak var selectedButton1: NSTextField!
    
    @IBOutlet weak var secondEditButton: NSImageView!
    @IBOutlet weak var secondModeTitle: NSTextField!
    @IBOutlet weak var secondBreakTime: NSTextField!
    @IBOutlet weak var secondWorkTime: NSTextField!
    @IBOutlet weak var selectedButton2: NSTextField!
    
    @IBOutlet weak var thirdEditButton: NSImageView!
    @IBOutlet weak var thirdModeTitle: NSTextField!
    @IBOutlet weak var thirdBreakTime: NSTextField!
    @IBOutlet weak var thirdWorkTime: NSTextField!
    @IBOutlet weak var selectedButton3: NSTextField!
    
    @IBOutlet weak var returnIcon: NSImageView!
    @IBOutlet weak var returnText: NSTextField!
    
    var previousViewController: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationButtons()
    }
    
    override func awakeFromNib() {
        StyleHelper.setGeneralStyles(self)
        
        initTextFields()
        loadInModes()
        initSelectButtons()
    }
    
    func initTextFields() {
        // Set placeholder colors
        StyleHelper.setPlaceholder(firstModeTitle, string: Strings.FirstModeTitle.rawValue, bold: true)
        StyleHelper.setPlaceholder(firstWorkTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        StyleHelper.setPlaceholder(firstBreakTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        
        StyleHelper.setPlaceholder(secondModeTitle, string: Strings.SecondModeTitle.rawValue, bold: true)
        StyleHelper.setPlaceholder(secondWorkTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        StyleHelper.setPlaceholder(secondBreakTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        
        StyleHelper.setPlaceholder(thirdModeTitle, string: Strings.ThirdModeTitle.rawValue, bold: true)
        StyleHelper.setPlaceholder(thirdWorkTime, string: Strings.TimePlaceholder.rawValue, bold: false)
        StyleHelper.setPlaceholder(thirdBreakTime, string: Strings.TimePlaceholder.rawValue, bold: false)
    }
    
    
    func initNavigationButtons() {
        let returnGesture = Helper.makeLeftClickGesture(self)
        returnGesture.action = #selector(SettingsViewController.returnToPrevViewController)
        returnIcon.addGestureRecognizer(returnGesture)
        returnText.addGestureRecognizer(returnGesture)
    }
    
    func loadInModes() {
        let allModes = DataManager.getModes()
        let firstMode = allModes.filter{ $0.orderNum == 0}.first
        let secondMode = allModes.filter{ $0.orderNum == 1}.first
        let thirdMode = allModes.filter{ $0.orderNum == 2}.first
        
        // Mode 1
        firstModeTitle.stringValue = firstMode!.name
        firstWorkTime.stringValue = TimeHelper.toTimeString(firstMode!.workCount as Int)
        firstBreakTime.stringValue = TimeHelper.toTimeString(firstMode!.breakCount as Int)
        
        // Mode 2
        secondModeTitle.stringValue = secondMode!.name
        secondWorkTime.stringValue = TimeHelper.toTimeString(secondMode!.workCount as Int)
        secondBreakTime.stringValue = TimeHelper.toTimeString(secondMode!.breakCount as Int)
        
        // Mode 3
        thirdModeTitle.stringValue = thirdMode!.name
        thirdWorkTime.stringValue = TimeHelper.toTimeString(thirdMode!.workCount as Int)
        thirdBreakTime.stringValue = TimeHelper.toTimeString(thirdMode!.breakCount as Int)
        
        // Select current mode
        let currentMode = DataManager.getContext()!.modeRelationship
        
        switch currentMode.orderNum {
        case 0:
            StyleHelper.setPlaceholder(selectedButton1, string: Strings.Selected.rawValue, bold: false)
            selectedButton1.stringValue = Strings.Selected.rawValue
        case 1:
            StyleHelper.setPlaceholder(selectedButton2, string: Strings.Selected.rawValue, bold: false)
            selectedButton2.stringValue = Strings.Selected.rawValue
        case 2:
            StyleHelper.setPlaceholder(selectedButton3, string: Strings.Selected.rawValue, bold: false)
            selectedButton3.stringValue = Strings.Selected.rawValue
        default:
            break
        }
    }
    
    func initSelectButtons() {
        let gesture1 = Helper.makeLeftClickGesture(self)
        gesture1.action = #selector(SettingsViewController.selectFirstMode)
        selectedButton1.addGestureRecognizer(gesture1)
        
        let gesture2 = Helper.makeLeftClickGesture(self)
        gesture2.action = #selector(SettingsViewController.selectSecondMode)
        selectedButton2.addGestureRecognizer(gesture2)
        
        let gesture3 = Helper.makeLeftClickGesture(self)
        gesture3.action = #selector(SettingsViewController.selectThirdMode)
        selectedButton3.addGestureRecognizer(gesture3)
    }
    
    func selectFirstMode() {
        DataManager.changeMode(0)
        StyleHelper.setPlaceholder(selectedButton1, string: Strings.Selected.rawValue, bold: false)
        selectedButton1.stringValue = Strings.Selected.rawValue
        selectedButton2.stringValue = Strings.Unselected.rawValue
        selectedButton3.stringValue = Strings.Unselected.rawValue
    }
    
    func selectSecondMode() {
        DataManager.changeMode(1)
        StyleHelper.setPlaceholder(selectedButton2, string: Strings.Selected.rawValue, bold: false)
        selectedButton1.stringValue = Strings.Unselected.rawValue
        selectedButton2.stringValue = Strings.Selected.rawValue
        selectedButton3.stringValue = Strings.Unselected.rawValue
    }
    
    func selectThirdMode() {
        DataManager.changeMode(2)
        StyleHelper.setPlaceholder(selectedButton3, string: Strings.Selected.rawValue, bold: false)
        selectedButton3.stringValue = Strings.Selected.rawValue
        selectedButton1.stringValue = Strings.Unselected.rawValue
        selectedButton2.stringValue = Strings.Unselected.rawValue
    }
    
    func returnToPrevViewController() {
        Helper.returnToPrevViewController(self, destination: previousViewController!)
    }

    func setPrevViewController(prevVc: String) {
        previousViewController = prevVc
    }
}