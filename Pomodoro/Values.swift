//
//  Values.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/27/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

enum Keys: UInt16 {
    case ReturnKey = 36
}

enum DefaultWorkCount: Int {
    case Light = 900 // 60 * 15
    case Normal = 1800 // 60 * 30
    case Beast = 2700 // 60 * 45
}

enum DefaultBreakCount: Int {
    case Light = 300 // 60 * 5
    case Normal = 600 // 60 * 10
    case Beast = 900 // 60 * 15
}

enum DefaultModeNum: Int {
    case Light = 0
    case Normal = 1
    case Beast = 2
}