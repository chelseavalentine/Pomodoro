//
//  PomodoroScreenProtocol.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 10/17/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Foundation

protocol PomodoroScreenProtocol {
    func setPausedMode()
    func setRunningMode()
    func setStoppedMode()
    func updateProgressBar(percentage: Double)
    func isBreakView() -> Bool
}