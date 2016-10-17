//
//  ViewHelper.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 10/17/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Foundation
import Cocoa

class ViewHelper {
    private init() {
    }
    
    static func updateProgressBar(vc: NSViewController, bar: NSBox, percentage: CGFloat, startX: CGFloat) {
        let maxBarWidth: CGFloat = vc.view.frame.width - startX
        
        var newBarFrame: NSRect = bar.frame
        newBarFrame.origin.x = startX
        newBarFrame.size.width = maxBarWidth * percentage
        
        bar.frame = newBarFrame
    }
}