//
//  HomeStore.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import ComposableArchitecture
import Foundation

enum HomeScene: Hashable {
    case home
    case editPlot
}

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [HomeScene] = []
        
        var plotListCells: IdentifiedArrayOf<PlotListCellStore.State> = []
        
        var editPlot: EditPlotStore.State?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case refresh
        case addButtonTapped
        case fetchResponse([Plot])
        
        case plotListCell(id: PlotListCellStore.State.ID, action: PlotListCellStore.Action)
        case editPlot(EditPlotStore.Action)
    }
    
    @Dependency(\.plotClient) var plotClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
                
            case .refresh:
                return .send(.fetchResponse(plotClient.fetch()))
                
            case .addButtonTapped:
                state.editPlot = .init(.init(plot: plotClient.newPlot))
                state.path.append(.editPlot)
                return .none
                
            case let .fetchResponse(plots):
                state.plotListCells = []
                plots.forEach({ plot in
                    state.plotListCells.append(.init(id: .init(), plot: plot))
                })
                return .none
                
            case let .plotListCell(id, action):
                switch action {
                case .tapped:
                    if let plot = state.plotListCells.first(where: { $0.id == id })?.plot {
                        state.editPlot = .init(plot: plot)
                        state.path.append(.editPlot)
                    }
                    return .none
                }
                
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
