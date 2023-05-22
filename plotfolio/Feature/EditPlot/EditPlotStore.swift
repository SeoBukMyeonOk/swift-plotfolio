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
        
        var point: Double
        var date: Date
        var type: Int16
        
        init(plot: Plot) {
            self.plot = plot
            self.point = plot.point
            self.date = plot.date ?? .init()
            self.type = plot.type
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        
        case titleChanged(String)
        case contentChanged(String)
        case dateChanged(Date)
        case typeChanged(Int16)
        case pointChanged(Double)
        
        case saveRequest
        
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
                return .send(.saveRequest)
                
            case let .contentChanged(content):
                state.plot.content = content
                return .send(.saveRequest)
                
            case let .dateChanged(date):
                state.plot.date = date
                state.date = date
                return .send(.saveRequest)
                
            case let .typeChanged(type):
                state.plot.type = type
                state.type = type
                return .send(.saveRequest)
                
            case let .pointChanged(point):
                state.plot.point = point
                state.point = point
                return .send(.saveRequest)
                
            case .saveRequest:
                if state.plot.title?.isEmpty == false || state.plot.content?.isEmpty == false {
                    plotClient.save()
                }
                return .none
                
            case .plotListCell:
                return .none
            }
        }
    }
}
