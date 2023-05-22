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
        var plot: Plot = .init()
//        var title: String = ""
//        var content: String = ""
//        var date: Date = .init()
//        var type: PlotType = .media
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case titleChanged(String)
        case contentChanged(String)
        case dateChanged(Date)
        case typeChanged(Int)
        case saveButtonTapped
        
        case saveResponse(TaskResult<Plot>)
        
        case plotListCell(id: PlotListCellStore.State.ID, action: PlotListCellStore.Action)
    }
    
    @Dependency(\.plotClient) var plotClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .titleChanged(title):
                state.plot.title = title
                return .none
                
            case let .contentChanged(content):
                state.plot.content = content
                return .none
                
            case let .dateChanged(date):
                state.plot.date = date
                return .none
                
            case let .typeChanged(type):
                state.plot.type = Int16(type)
                return .none
                
            case .saveButtonTapped:
                return .task { [plot = state.plot] in
                    await .saveResponse(
                        TaskResult { try await self.plotClient.save(plot) }
                    )
                }
                return .none
                
            case .plotListCell:
                return .none
                
            case .saveResponse(_):
                return .none
            }
        }
        .forEach(\.plotListCells, action: /Action.plotListCell(id:action:)) {
            PlotListCellStore()
        }
    }
}
