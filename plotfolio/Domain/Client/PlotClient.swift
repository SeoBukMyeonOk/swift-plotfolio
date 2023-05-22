//
//  PlotClient.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import Foundation

import ComposableArchitecture
import CoreData

public struct PlotClient {
    var newPlot: Plot
    var fetch: () -> [Plot]
    var save: () -> ()
    var delete: (NSManagedObjectID) -> ()
}

extension PlotClient: TestDependencyKey {
    public static let previewValue = Self(
        newPlot: PlotCloudManager.shared.newPlot,
        fetch: { [] },
        save: { },
        delete: { _ in }
    )
    
    public static let testValue = Self(
        newPlot: unimplemented("\(Self.self).newPlot"),
        fetch: unimplemented("\(Self.self).fetch"),
        save: unimplemented("\(Self.self).save"),
        delete: unimplemented("\(Self.self).delete")
    )
}

extension DependencyValues {
    var plotClient: PlotClient {
        get { self[PlotClient.self] }
        set { self[PlotClient.self] = newValue }
    }
}

// TODO: mock 말고 실제 API 연동 해야함
extension PlotClient: DependencyKey {
    static public let liveValue = PlotClient(
        newPlot: PlotCloudManager.shared.newPlot,
        fetch: { PlotCloudManager.shared.fetch() },
        save: { PlotCloudManager.shared.save() },
        delete: { id in PlotCloudManager.shared.delete(id: id) }
    )
}
