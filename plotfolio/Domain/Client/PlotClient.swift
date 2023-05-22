//
//  PlotClient.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import Foundation

import ComposableArchitecture

public struct PlotClient {
    var newPlot: Plot
    var fetch: () -> [Plot]
    var save: () -> ()
}

extension PlotClient: TestDependencyKey {
    public static let previewValue = Self(
        newPlot: PlotCloudManager.shared.newPlot,
        fetch: { [] },
        save: { }
    )
    
    public static let testValue = Self(
        newPlot: unimplemented("\(Self.self).newPlot"),
        fetch: unimplemented("\(Self.self).fetch"),
        save: unimplemented("\(Self.self).save")
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
        save: { PlotCloudManager.shared.save() }
    )
}

