//
//  DataManager.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 10/3/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

class DataManager {
    static let sharedInstance = DataManager()
    static let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
    
    private init() {
    }
    
    static func getContext() -> ContextEntity? {
        let contexts = getObjects("ContextEntity") as! [ContextEntity]
        return contexts.last
    }
    
    static func getMode(modeNum: Int) -> ModeEntity {
        let modes = getObjects("ModeEntity") as! [ModeEntity]
        return modes[modeNum]
    }
    
    static func getModes() -> [ModeEntity] {
        return getObjects("ModeEntity") as! [ModeEntity]
    }
    
    static func createMode(order: Int, name: String, workCount: Int, breakCount: Int, selected: Bool) -> (ModeEntity, NSManagedObjectContext) {
        let managedContext = appDelegate.managedObjectContext
        let modeEntity = NSEntityDescription.entityForName("ModeEntity", inManagedObjectContext: managedContext)
        let mode = ModeEntity(entity: modeEntity!, insertIntoManagedObjectContext: managedContext)
        
        mode.created = NSDate()
        mode.orderNum = order
        mode.name = name
        mode.workCount = workCount
        mode.breakCount = breakCount
        mode.selected = selected
        
        return (mode, managedContext);
    }
    static func saveMode(order: Int, name: String, workCount: Int, breakCount: Int, selected: Bool) {
        let (_, managedContext) = createMode(order, name: name, workCount: workCount, breakCount: breakCount, selected: selected)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the mode. \(error), \(error.userInfo) :(")
        }
    }
    
    static func saveModeWithCallback(order: Int, name: String, workCount: Int, breakCount: Int, selected: Bool, callback: (ModeEntity) -> ()) {
        let (mode, managedContext) = createMode(order, name: name, workCount: workCount, breakCount: breakCount, selected: selected)
        
        do {
            try managedContext.save()
            callback(mode)
        } catch let error as NSError {
            print("Couldn't save the mode. \(error), \(error.userInfo) :(")
        }
    }
    
    static func getSessions() -> [SessionEntity] {
        return getObjects("SessionEntity") as! [SessionEntity]
    }
    
    static func initAndReturnSession(mode: ModeEntity) -> SessionEntity {
        let managedContext = appDelegate.managedObjectContext
        let sessionEntity = NSEntityDescription.entityForName("SessionEntity", inManagedObjectContext: managedContext)
        let session = SessionEntity(entity: sessionEntity!, insertIntoManagedObjectContext: managedContext)
        
        session.modeRelationship = mode
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the session. \(error), \(error.userInfo) :(")
        }
        
        return session
    }
    
    static func setCurrentMode(mode: ModeEntity) {
        let managedContext = appDelegate.managedObjectContext
        let context = getContext()
        context?.modeRelationship = mode
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
    
    static func changeMode(num: Int) {
        let managedContext = appDelegate.managedObjectContext
        let context = getContext()
        let modes = getModes().filter({ $0.isArchived == false })
    
        for mode in modes {
            if mode.orderNum == num {
                mode.selected = true
                context?.modeRelationship = mode
            } else {
                mode.selected = false
            }
        }
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
    
    static func saveSession(goal: String, result: String, started: NSDate, ended: NSDate, mode: ModeEntity, numPaused: Int) {
        let managedContext = appDelegate.managedObjectContext
        let sessionEntity = NSEntityDescription.entityForName("SessionEntity", inManagedObjectContext: managedContext)
        let session = SessionEntity(entity: sessionEntity!, insertIntoManagedObjectContext: managedContext)
        
        session.goal = goal
        session.result = result
        session.started = started
        session.ended = ended
        session.modeRelationship = mode
        session.numPausedTimes = numPaused
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the session. \(error), \(error.userInfo) :(")
        }
    }
    
    
    static func createContext(mode: ModeEntity, isBreak: Bool) {
        let managedContext = appDelegate.managedObjectContext
        let contextEntity = NSEntityDescription.entityForName("ContextEntity", inManagedObjectContext: managedContext)
        let context = ContextEntity(entity: contextEntity!, insertIntoManagedObjectContext: managedContext)
        
        let sessionEntity = NSEntityDescription.entityForName("SessionEntity", inManagedObjectContext: managedContext)
        let session = SessionEntity(entity: sessionEntity!, insertIntoManagedObjectContext: managedContext)
        
        session.modeRelationship = mode
        
        context.modeRelationship = mode
        context.sessionRelationship = session
        context.isBreak = isBreak
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
    
    static func saveManagedContext() {
        let managedContext = appDelegate.managedObjectContext
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
    
    static func createSession(mode: ModeEntity, num: Int) {
        let managedContext = appDelegate.managedObjectContext
        let sessionEntity = NSEntityDescription.entityForName("SessionEntity", inManagedObjectContext: managedContext)
        let session = SessionEntity(entity: sessionEntity!, insertIntoManagedObjectContext: managedContext)
        session.modeRelationship = mode
        session.num = num
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
    
    static func getObjects(entityName: String) -> [AnyObject] {
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results
        } catch let error as NSError {
            print("Couldn't fetch the context. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    static func deleteObject(obj: NSManagedObject) {
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.deleteObject(obj)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
    
    static func deleteObjects(objs: [NSManagedObject]) {
        let managedContext = appDelegate.managedObjectContext
        
        for obj in objs {
            managedContext.deleteObject(obj)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
}