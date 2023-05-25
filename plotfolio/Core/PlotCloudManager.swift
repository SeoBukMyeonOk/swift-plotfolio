//
//  PlotCloudHelper.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import Foundation

import CloudKit
import CoreData

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
    func newPlot() -> Plot {
        let viewContext = self.persistentContainer.viewContext
        viewContext.reset()
        
        let newPlot = Plot(context: viewContext)
        
        newPlot.title = ""
        newPlot.content = ""
        newPlot.type = 0
        newPlot.date = .init()
        
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
    
    func fetch(id: NSManagedObjectID) -> Plot? {
        let viewContext = self.persistentContainer.viewContext
        
        do {
            return try viewContext.existingObject(with: id) as? Plot
        } catch {
            print(error)
            return nil
        }
    }
    
    func save() {
        let viewContext = self.persistentContainer.viewContext

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func delete(id: NSManagedObjectID) {
        let viewContext = self.persistentContainer.viewContext
        
        if let plot = self.fetch(id: id) {
            viewContext.delete(plot)
            self.save()
        }
    }
}
