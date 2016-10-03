//
//  ModeEntity+CoreDataProperties.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 10/3/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ModeEntity {

    @NSManaged var breakCount: NSNumber
    @NSManaged var created: NSDate
    @NSManaged var isArchived: NSNumber
    @NSManaged var name: String
    @NSManaged var orderNum: NSNumber
    @NSManaged var selected: NSNumber
    @NSManaged var workCount: NSNumber
    @NSManaged var contextRelationship: ContextEntity
    @NSManaged var sessionRelationship: SessionEntity

}
