//
//  TimeHelper.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 10/17/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Foundation

class TimeHelper {
    private init() {
    }
    
    static func toTimeString(count: Int) -> String {
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
}