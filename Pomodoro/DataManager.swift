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
    
    static func getCycle(cycleNum: Int) -> CycleEntity {
        let cycles = getObjects("CycleEntity") as! [CycleEntity]
        return cycles[cycleNum]
    }
    
    static func getCycles() -> [CycleEntity] {
        return getObjects("CycleEntity") as! [CycleEntity]
    }
    
    static func createCycle(order: Int, name: String, workCount: Int, breakCount: Int, selected: Bool) -> (CycleEntity, NSManagedObjectContext) {
        let managedContext = appDelegate.managedObjectContext
        let cycleEntity = NSEntityDescription.entityForName("CycleEntity", inManagedObjectContext: managedContext)
        let cycle = CycleEntity(entity: cycleEntity!, insertIntoManagedObjectContext: managedContext)
        
        cycle.created = NSDate()
        cycle.orderNum = order
        cycle.name = name
        cycle.workCount = workCount
        cycle.breakCount = breakCount
        cycle.selected = selected
        
        return (cycle, managedContext);
    }
    static func saveCycle(order: Int, name: String, workCount: Int, breakCount: Int, selected: Bool) {
        let (_, managedContext) = createCycle(order, name: name, workCount: workCount, breakCount: breakCount, selected: selected)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the cycle. \(error), \(error.userInfo) :(")
        }
    }
    
    static func saveCycleWithCallback(order: Int, name: String, workCount: Int, breakCount: Int, selected: Bool, callback: (CycleEntity) -> ()) {
        let (cycle, managedContext) = createCycle(order, name: name, workCount: workCount, breakCount: breakCount, selected: selected)
        
        do {
            try managedContext.save()
            callback(cycle)
        } catch let error as NSError {
            print("Couldn't save the cycle. \(error), \(error.userInfo) :(")
        }
    }
    
    static func getSession() {
        let sessions = getObjects("SessionEntity") as! [SessionEntity]
    }
    
    static func getSessions() {
        let sessions = getObjects("SessionEntity") as! [SessionEntity]
    }
    
    static func initAndReturnSession(cycle: CycleEntity) -> SessionEntity {
        let managedContext = appDelegate.managedObjectContext
        let sessionEntity = NSEntityDescription.entityForName("SessionEntity", inManagedObjectContext: managedContext)
        let session = SessionEntity(entity: sessionEntity!, insertIntoManagedObjectContext: managedContext)
        
        session.cycleRelationship = cycle
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the session. \(error), \(error.userInfo) :(")
        }
        
        return session
    }
    
    static func setCurrentMode(cycle: CycleEntity) {
        let managedContext = appDelegate.managedObjectContext
        let context = getContext()
        context?.cycleRelationship = cycle
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
    
    static func changeMode(num: Int) {
        let managedContext = appDelegate.managedObjectContext
        let modes = getCycles().filter({ $0.isArchived == false })
        
        print("changing mode to \(num)")
        for mode in modes {
            if mode.orderNum == num {
                mode.selected = true
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
    
    static func saveSession(goal: String, result: String, started: NSDate, ended: NSDate, cycle: CycleEntity, numPaused: Int) {
        let managedContext = appDelegate.managedObjectContext
        let sessionEntity = NSEntityDescription.entityForName("SessionEntity", inManagedObjectContext: managedContext)
        let session = SessionEntity(entity: sessionEntity!, insertIntoManagedObjectContext: managedContext)
        
        session.goal = goal
        session.result = result
        session.started = started
        session.ended = ended
        session.cycleRelationship = cycle
        session.numPausedTimes = numPaused
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the session. \(error), \(error.userInfo) :(")
        }
    }
    
    
    static func createContext(cycle: CycleEntity, session: SessionEntity, isBreak: Bool) {
        let managedContext = appDelegate.managedObjectContext
        let contextEntity = NSEntityDescription.entityForName("ContextEntity", inManagedObjectContext: managedContext)
        let context = ContextEntity(entity: contextEntity!, insertIntoManagedObjectContext: managedContext)
        
        context.cycleRelationship = cycle
        context.sessionRelationship = session
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn't save the context. \(error), \(error.userInfo) :(")
        }
    }
    
    static func createSession() {
        let managedContext = appDelegate.managedObjectContext
        let sessionEntity = NSEntityDescription.entityForName("SessionEntity", inManagedObjectContext: managedContext)
        let _ = SessionEntity(entity: sessionEntity!, insertIntoManagedObjectContext: managedContext)
        
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