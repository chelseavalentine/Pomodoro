//
//  DataManager.swift
//  Pomodoro
//
//  Created by Chelsea Valentine on 10/3/16.
//  Copyright © 2016 Chelsea Valentine. All rights reserved.
//

import Cocoa

extension NSManagedObjectContext
{
    func deleteAllData()
    {
        guard let persistentStore = persistentStoreCoordinator?.persistentStores.last else {
            return
        }
        
        guard let url = persistentStoreCoordinator?.URLForPersistentStore(persistentStore) else {
            return
        }
        
        performBlockAndWait { () -> Void in
            self.reset()
            do
            {
                try self.persistentStoreCoordinator?.removePersistentStore(persistentStore)
                try NSFileManager.defaultManager().removeItemAtURL(url)
                try self.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            }
            catch { /*dealing with errors up to the usage*/ }
        }
    }
}

class DataManager {
    static let sharedInstance = DataManager()
    static let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
    
    private init() {
    }
    
    static func getContext() -> ContextEntity? {
        
        let contexts = getObjects("ContextEntity") as! [ContextEntity]
        return contexts.last
    }
    
    static func getCycle() {
        let cycles = getObjects("CycleEntity") as! [CycleEntity]
    }
    
    static func saveCycle(order: Int, name: String, workCount: Int, breakCount: Int) {
        let managedContext = appDelegate.managedObjectContext
        let deleting = NSManagedObjectContext.deleteAllData(managedContext)
        let cycleEntity = NSEntityDescription.entityForName("CycleEntity", inManagedObjectContext: managedContext)
        let cycle = CycleEntity(entity: cycleEntity!, insertIntoManagedObjectContext: managedContext)
        
        cycle.orderNum = order
        cycle.name = name
        cycle.workCount = workCount
        cycle.breakCount = breakCount
        
        print(cycle)
        
        do {
            try managedContext.save()
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
    }
    
    
    static func createContext() {
        let managedContext = appDelegate.managedObjectContext
        let contextEntity = NSEntityDescription.entityForName("ContextEntity", inManagedObjectContext: managedContext)
        let _ = ContextEntity(entity: contextEntity!, insertIntoManagedObjectContext: managedContext)
        
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
            print(results)
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