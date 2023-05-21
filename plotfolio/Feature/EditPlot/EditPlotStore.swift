//
//  EditPlotStore.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import Foundation

import ComposableArchitecture

struct EditPlotStore: ReducerProtocol {
    struct State: Equatable {
        var plotListCells: IdentifiedArrayOf<PlotListCellStore.State> = [
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init())
        ]
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case plotListCell(id: PlotListCellStore.State.ID, action: PlotListCellStore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
                
            case .plotListCell:
                return .none
            }
        }
        .forEach(\.plotListCells, action: /Action.plotListCell(id:action:)) {
          PlotListCellStore()
        }
    }
}
