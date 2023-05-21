//
//  HomeStore.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import ComposableArchitecture

enum HomeScene: Hashable {
    case home
    case editPlot
}

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [HomeScene] = []
        
        var plotListCells: IdentifiedArrayOf<PlotListCellStore.State> = [
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
            .init(id: .init()),
        ]
        
        var editPlot: EditPlotStore.State?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case addButtonTapped
        
        case plotListCell(id: PlotListCellStore.State.ID, action: PlotListCellStore.Action)
        case editPlot(EditPlotStore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
                
            case .addButtonTapped:
                state.editPlot = .init()
                state.path.append(.editPlot)
                return .none
                
            case .plotListCell:
                return .none
                
            case .editPlot:
                return .none
            }
        }
        .forEach(\.plotListCells, action: /Action.plotListCell(id:action:)) {
          PlotListCellStore()
        }
        .ifLet(\.editPlot, action: /Action.editPlot) {
            EditPlotStore()
        }
    }
}
