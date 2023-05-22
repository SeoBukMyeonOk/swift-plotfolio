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
        var plot: Plot
        
        var type: Int16
        
        init(plot: Plot) {
            self.plot = plot
            self.type = plot.type
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case titleChanged(String)
        case contentChanged(String)
        case dateChanged(Date)
        case typeChanged(Int16)
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
                state.plot.type = type
                state.type = type
                return .none
                
            case .saveButtonTapped:
                plotClient.save()
                return .none
                
            case .plotListCell:
                return .none
                
            case .saveResponse(_):
                return .none
            }
        }
    }
}
