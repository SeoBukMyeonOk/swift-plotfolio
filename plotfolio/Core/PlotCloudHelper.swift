//
//  PlotCloudHelper.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import Foundation

import CloudKit

enum FetchError {
    case addingError
    case fetchingError
    case deletingError
    case noRecords
    case none
}

struct PlotCloudHelper {
    private let recordType = "Plot"
    private let containerName = "iCloud.plotfolio"
    
    func fetchTasks(completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        let publicDatabase = CKContainer(identifier: containerName).publicCloudDatabase
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        publicDatabase.fetch(
            withQuery: query,
            inZoneWith: CKRecordZone.default().zoneID,
            completionHandler: { (records, error) -> Void in
                self.processQueryResponseWith(
                    records: records,
                    error: error as NSError?,
                    completion: { fetchedRecords, fetchError in
                        completion(fetchedRecords, fetchError)
                    })
            })
    }
    
    func addTask(_ task: String, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        
    }
    
    func deleteRecord(record: CKRecord, completionHandler: @escaping (FetchError) -> Void) {
        
    }
    
    func updateTask(_ task: CKRecord, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        
    }
    
    private func processQueryResponseWith(
        records: [CKRecord]?,
        error: NSError?,
        completion: @escaping ([CKRecord]?, FetchError)
        -> Void
    ) {
        guard error == nil else {
            completion(nil, .fetchingError)
            return
        }
        
        guard let records = records, records.count > 0 else {
            completion(nil, .noRecords)
            return
        }
        
        completion(records, .none)
    }
}
