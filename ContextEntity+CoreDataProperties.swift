//
//  ContextEntity+CoreDataProperties.swift
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

extension ContextEntity {

    @NSManaged var isBreak: NSNumber?
    @NSManaged var count: NSNumber?
    @NSManaged var cycleRelationship: CycleEntity?
    @NSManaged var sessionRelationship: SessionEntity?

}
