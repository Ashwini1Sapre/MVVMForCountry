//
//  CoreDataStack.swift
//  MVVMForCountry
//
//  Created by Knoxpo MacBook Pro on 10/05/21.
//

import Foundation
import CoreData
import Combine


protocol PersistentStore {
    typealias DBOpration<Result> = (NSManagedObjectContext) throws -> Result
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error>
    func fetch<T, V>(_ fetchREquest: NSFetchRequest<T>, map: @escaping (T) throws -> V?) -> AnyPublisher<LazyList<V>, Error>
    func update<Result>(_ opration: @escaping DBOpration<Result>) -> AnyPublisher<Result, Error>
}

struct CoreDataStack: PersistentStore {
    
    private let container: NSPersistentContainer
    private let isStoredLoaaded = CurrentValueSubject<Bool, Error>(false)
    private let bgQueue = DispatchQueue(label: "coredata")
    
    init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask, version vNumber: UInt) {
        
        let version = Version(vNumber)
        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFailURL(directory, domainMask){
        let store = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [store]
        
    }
        
        bgQueue.async {[weak isStoredLoaaded, weak container] in
            container?.loadPersistentStores { (storeDescription , error) in
                
                DispatchQueue.main.async {
                    if let error = error {
                        
                        isStoredLoaaded?.send(completion: .failure(error))
                        
                    }
                    else
                    {
                        
                        container?.viewContext.configureAsReadOnlyContext()
                        isStoredLoaaded?.value = true
                    }
                }
                
                
                
                
            }
        }
        
        
        
    }
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> {
        return onStoreISReady
            .flatMap { [weak container] in
                Future<Int, Error> { promise in
                    do {
                        let count = try container?.viewContext.count(for: fetchRequest) ?? 0
                        promise(.success(count))
                        
                        
                    } catch {
                        promise(.failure(error))
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
            }
            .eraseToAnyPublisher()
        
        
        
        
    }
    
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping (T) throws -> V?) -> AnyPublisher<LazyList<V>, Error> {
        
        assert(Thread.isMainThread)
        let fetch = Future<LazyList<V>, Error> { [weak container] promise in
            guard let context = container?.viewContext else { return }
            
            context.performAndWait {
                do {
                    let managedObjects = try context.fetch(fetchRequest)
                    let results = LazyList<V>(count: managedObjects.count, useCache: true) { [weak context] in
                        
                        let object = managedObjects[$0]
                        let mapped = try map(object)
                        if let mo = object as? NSManagedObject {
                            context?.refresh(mo, mergeChanges: false)
                        }
                        return mapped
                        
                        
                    }
                    
                    promise(.success(results))
                    
                    
                }
                catch {
                    promise(.failure(error))
                }
                
                
                
                
                
                
                
            }
            
            
            
        }
        
        return onStoreISReady
            .flatMap { fetch }
            .eraseToAnyPublisher()
        
        
        
        
        
        
    
    }
    
    
    func update<Result>(_ opration: @escaping DBOpration<Result>) -> AnyPublisher<Result, Error> {
        
        let update = Future<Result, Error> { [weak bgQueue, weak container] promise in
            bgQueue?.async {
                
                guard let context = container?.newBackgroundContext() else { return }
                
                context.configureAsUpdateContext()
                context.performAndWait {
                    
                    do {
                        let result = try opration(context)
                        if context.hasChanges {
                            try context.save()
                        }
                        context.reset()
                        promise(.success(result))
                        
                        
                    }catch {
                        context.reset()
                        promise(.failure(error))
                    }
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
            
            
            
        }
        
        return onStoreISReady
            .flatMap { update }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        
        
        
    }
    
    
    
    
    private var onStoreISReady: AnyPublisher<Void, Error> {
        
        return isStoredLoaaded
            .filter { $0 }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    
    
}

extension CoreDataStack.Version {
    
    static var actual: UInt { 1 }
}

extension CoreDataStack {
    
    struct Version {
        private let number: UInt
   
    init(_ number: UInt) {
        self.number = number
    }
        var modelName:String {
            
            return "MVVMForCountry"
        }
        func dbFailURL(_ directory: FileManager.SearchPathDirectory,
                       _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            
            return FileManager.default
                .urls(for: directory, in: domainMask).first?
                .appendingPathComponent(subpathToDb)
            
            
        }
        
        private var subpathToDb: String {
            
            
            return "db.sql"
        }
        
        
    
    }
    
    
}
