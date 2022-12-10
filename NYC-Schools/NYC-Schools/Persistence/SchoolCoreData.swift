//
//  SchoolCoreDataDB.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import CoreData
import Combine


// MARK: - Fetch Requests

extension SchoolMO {
    static func schoolListRequest(_ page: Int, limit: Int) -> NSFetchRequest<SchoolMO> {
        let request = SchoolMO.fetchRequest()
        request.fetchLimit = limit
        request.fetchOffset = page * limit
        
        return request
    }
}

// MARK: - Persistent Store API

protocol PersistentStore {
    typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
    
    func fetchSchools(_ fetchRequest: NSFetchRequest<SchoolMO>) -> AnyPublisher<[School], Error>
    
    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error>
}

// MARK: - Persistent Store

struct SchoolCoreDataDB: PersistentStore {
    
    private let container: NSPersistentContainer
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    private let bgQueue = DispatchQueue(label: "com.xwu.coredata.background.queue")
    
    init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask) {

        container = NSPersistentContainer(name: "db_schools")
        if let url = FileManager.default
            .urls(for: directory, in: domainMask).first?
            .appendingPathComponent("db_schools.sql") {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }
        bgQueue.async { [weak isStoreLoaded, weak container] in
            container?.loadPersistentStores { (storeDescription, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        isStoreLoaded?.send(completion: .failure(error))
                    } else {
                        try? container?.viewContext.setQueryGenerationFrom(.current)
                        container?.viewContext.automaticallyMergesChangesFromParent = true
                        container?.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                        isStoreLoaded?.value = true
                    }
                }
            }
        }
    }
    
    /*
       Fetch school data from db
     */
    func fetchSchools(_ fetchRequest: NSFetchRequest<SchoolMO>) -> AnyPublisher<[School], Error> {
        assert(Thread.isMainThread)
        let fetch = Future<[School], Error> { [weak container] promise in
            guard let context = container?.viewContext else { return }
            context.performAndWait {
                self.configureManagedObjectContext(context)
                do {
                    let managedObjects = try context.fetch(fetchRequest)
                    let results = managedObjects.map { $0.toDTO() }
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        return onStoreIsReady
            .flatMap { fetch }
            .eraseToAnyPublisher()
    }
    
    /*
       Save school data to db
     */
    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
        let update = Future<Result, Error> { [weak bgQueue, weak container] promise in
            bgQueue?.async {
                guard let context = container?.newBackgroundContext() else { return }
                context.performAndWait {
                    do {
                        let result = try operation(context)
                        if context.hasChanges {
                            try context.save()
                        }
                        context.reset()
                        promise(.success(result))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
            }
        }
        return onStoreIsReady
            .flatMap { update }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private var onStoreIsReady: AnyPublisher<Void, Error> {
        return isStoreLoaded
            .filter { $0 }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    private func configureManagedObjectContext(_ context: NSManagedObjectContext) {
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
