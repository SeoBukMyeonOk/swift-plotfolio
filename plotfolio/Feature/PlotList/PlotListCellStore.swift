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
        var description = ""
        var isComplete = false
    }
    
    enum Action: Equatable {
        case checkBoxToggled
        case textFieldChanged(String)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .checkBoxToggled:
            state.isComplete.toggle()
            return .none
            
        case let .textFieldChanged(description):
            state.description = description
            return .none
        }
    }
}
