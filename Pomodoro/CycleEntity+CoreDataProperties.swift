//
//  CycleEntity+CoreDataProperties.swift
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

extension CycleEntity {

    @NSManaged var breakCount: NSNumber?
    @NSManaged var name: String?
    @NSManaged var selected: NSNumber?
    @NSManaged var created: NSDate?
    @NSManaged var orderNum: NSNumber?
    @NSManaged var isArchived: NSNumber?
    @NSManaged var workCount: NSNumber?

}
