//
//  PlotListCellStore.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import Foundation

import ComposableArchitecture

struct PlotListCellStore: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id: UUID
        let plot: Plot
    }
    
    enum Action: Equatable {
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        }
    }
}
