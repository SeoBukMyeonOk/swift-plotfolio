//
//  PlotClient.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import Foundation

import ComposableArchitecture

public struct PlotClient {
    var fetch: @Sendable () async throws -> [Plot]
    var save: @Sendable (Plot) async throws -> Plot
}

extension PlotClient: TestDependencyKey {
    public static let previewValue = Self(
        fetch: { [] },
        save: { _ in .init() }
    )
    
    public static let testValue = Self(
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
        fetch: {
            PlotCloudHelper.shared.fetchTasks(completion: {_,_ in })
            return []
        },
        save: { plot in
            PlotCloudHelper.shared.save(plot)
            return plot
        }
    )
}

