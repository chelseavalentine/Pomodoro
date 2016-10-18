//
//  ViewHelper.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 10/17/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class ViewHelper {
    private init() {
    }
    
    static func updateProgressBar(vc: NSViewController, bar: NSBox, percentage: Double, startX: CGFloat) {
        let maxBarWidth: Double = Double(vc.view.frame.width) - Double(startX)
        let roundedPercentage: Double = round(10 * (1 + percentage))/10
        let newWidth = maxBarWidth * roundedPercentage
        
        if newWidth > Double(bar.frame.width) {
            var newBarFrame: NSRect = bar.frame
            newBarFrame.origin.x = startX
            newBarFrame.size.width = CGFloat(newWidth)
            
            bar.frame = newBarFrame
        }
    }
}