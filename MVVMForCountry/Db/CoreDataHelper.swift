//
//  CoreDataHelper.swift
//  MVVMForCountry
//
//  Created by Knoxpo MacBook Pro on 10/05/21.
//


import CoreData
import Combine

protocol ManageEntity: NSFetchRequestResult {
    
}

extension ManageEntity where Self: NSManagedObject {
    
    static var entityName: String {
        
        let nameMO = String(describing: Self.self)
        let suffixIndex = nameMO.index(nameMO.endIndex, offsetBy: -2)
        return String(nameMO[..<suffixIndex])
        
        
    }
    
    static func insertNew(in context: NSManagedObjectContext) -> Self? {
        return NSEntityDescription
            .insertNewObject(forEntityName: entityName, into: context) as? Self
        
    }
    
    static func newFetchRequest() -> NSFetchRequest<Self> {
        return .init(entityName: entityName)
    }
    
    
    
}


extension NSManagedObjectContext {
    
    func configureAsReadOnlyContext() {
        automaticallyMergesChangesFromParent = true
        mergePolicy = NSRollbackMergePolicy
        undoManager = nil
        shouldDeleteInaccessibleFaults = true
        
        
    }
    
    
    func configureAsUpdateContext() {
        mergePolicy =  NSOverwriteMergePolicy
        undoManager = nil
        
    }
    
    
}

extension NSSet {
    
    
    func toArray<T>(of type: T.Type) -> [T] {
        
        allObjects.compactMap { $0 as? T }
    }
    
}
