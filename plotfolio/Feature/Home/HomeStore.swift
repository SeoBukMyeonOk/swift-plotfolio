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
    case setting
}

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [HomeScene] = []
        
        var searchQuery: String = ""
        
        var plotListCells: IdentifiedArrayOf<PlotListCellStore.State> = []
        var filteredPlotListCells: IdentifiedArrayOf<PlotListCellStore.State> = []
        var editPlot: EditPlotStore.State?
        var setting: SettingStore.State?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case refresh
        case addButtonTapped
        case settingButtonTapped
        case fetchResponse([Plot])
        case search(String)
        case delete(IndexSet)
        
        case plotListCell(id: PlotListCellStore.State.ID, action: PlotListCellStore.Action)
        case editPlot(EditPlotStore.Action)
        case setting(SettingStore.Action)
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
                
            case .settingButtonTapped:
                state.setting = .init()
                state.path.append(.setting)
                return .none
                
            case let .search(searchQuery):
                state.searchQuery = searchQuery
                guard searchQuery.isEmpty == false else {
                    state.filteredPlotListCells = state.plotListCells
                    return .none
                }
                
                state.filteredPlotListCells = state.plotListCells.filter({
                    $0.plot.title?.lowercased().contains(searchQuery.lowercased()) == true ||
                    $0.plot.content?.lowercased().contains(searchQuery.lowercased()) == true
                })
                
                return .none
                
            case let .fetchResponse(plots):
                state.plotListCells = []
                plots.forEach({ plot in
                    state.plotListCells.append(.init(id: .init(), plot: plot))
                })
                state.filteredPlotListCells = state.plotListCells
                return .none
                
            case let .delete(indexSet):
                for index in indexSet {
                    let id = state.plotListCells[index].plot.objectID
                    plotClient.delete(id)
                }
                return .send(.refresh)
                
            case let .plotListCell(id, action):
                switch action {
                case .tapped:
                    if let plot = state.plotListCells.first(where: { $0.id == id })?.plot {
                        state.editPlot = .init(plot: plot)
                        state.path.append(.editPlot)
                    }
                    return .none
                }
                
            case .editPlot, .setting:
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
