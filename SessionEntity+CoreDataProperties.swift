//
//  SessionEntity+CoreDataProperties.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 9/22/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SessionEntity {

    @NSManaged var started: NSDate?
    @NSManaged var ended: NSDate?
    @NSManaged var numPausedTimes: NSNumber?
    @NSManaged var cycleMode: NSNumber?
    @NSManaged var num: NSNumber?
    @NSManaged var goal: String?
    @NSManaged var result: String?
    @NSManaged var cycleRelationship: CycleEntity?

}
