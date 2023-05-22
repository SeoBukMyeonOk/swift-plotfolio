//
//  PlotCloudHelper.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import Foundation

import CloudKit
import CoreData

enum FetchError {
    case addingError
    case fetchingError
    case deletingError
    case noRecords
    case none
}

class PlotCloudManager {
    static let shared = PlotCloudManager()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "plotfolio")
        let storeDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
        
        let localUrl = storeDirectory.appendingPathComponent("Local.sqlite")
        let localStoreDescription =
        NSPersistentStoreDescription(url: localUrl)
        localStoreDescription.configuration = "Local"
        
        let cloudUrl = storeDirectory.appendingPathComponent("Cloud.sqlite")
        let cloudStoreDescription =
        NSPersistentStoreDescription(url: cloudUrl)
        cloudStoreDescription.configuration = "Cloud"
        
        cloudStoreDescription.cloudKitContainerOptions =
        NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.plotfolio")
        
        container.persistentStoreDescriptions = [
            cloudStoreDescription,
            localStoreDescription
        ]
        
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Could not load persistent stores. \(error!)")
            }
        }
        
        return container
    }()
}

extension PlotCloudManager {
    var newPlot: Plot {
        let viewContext = self.persistentContainer.viewContext
        let newPlot = Plot(context: viewContext)
        
        newPlot.title = ""
        newPlot.content = ""
        newPlot.type = 0
        
        return newPlot
    }
    
    func fetch() -> [Plot] {
        let viewContext = self.persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = .init(entityName: "Plot")
        
        do {
            return try viewContext.fetch(request) as! [Plot]
        } catch {
            print(error)
            return []
        }
    }
    
    func save() {
        let viewContext = self.persistentContainer.viewContext
//
//        let newPlot = Plot(context: viewContext)
//        newPlot.title = plot.title
//        newPlot.content = plot.content
//        newPlot.date = plot.date
//        newPlot.type = plot.type
//        newPlot.point = plot.point
//
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func fetchTasks(completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        try? print(persistentContainer.viewContext.fetch(.init(entityName: "Plot")))
    }
    
    func addTask(_ task: String, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        
    }
    
    func deleteRecord(record: CKRecord, completionHandler: @escaping (FetchError) -> Void) {
        
    }
    
    func updateTask(_ task: CKRecord, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        
    }
    
    
    
    //        func fetchTasks(completion: @escaping ([CKRecord]?, FetchError) -> Void) {
    //    //        let publicDatabase = CKContainer(identifier: containerName).publicCloudDatabase
    //    //        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
    //    //        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
    //
    //
    //            try? print(persistentContainer.viewContext.fetch(.init(entityName: "Plot")))
    //        }
    //
    //        func add() {
    //    //        let publicDatabase = CKContainer(identifier: containerName).publicCloudDatabase
    //            let record = CKRecord(recordType: "Plot")
    //
    //            record.setObject("test title" as __CKRecordObjCValue, forKey: "title")
    //            record.setObject(Date() as __CKRecordObjCValue, forKey: "date")
    //
    //            persistentContainer.
    //
    //            publicDatabase.save(record, completionHandler: { (record, error) in
    //              guard let _ = error else {
    //                completionHandler(record, .none)
    //                return
    //              }
    //
    //              completionHandler(nil, .addingError)
    //            })
    //        }
}
