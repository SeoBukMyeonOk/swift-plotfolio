//
//  HomeView.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    public let store: StoreOf<HomeStore>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(\.$path)) {
                VStack(spacing: .zero) {
                    List {
                        ForEachStore(self.store.scope(state: \.plotListCells, action: HomeStore.Action.plotListCell(id:action:))) {
                            PlotListCellView(store: $0)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action:{
                            viewStore.send(.addButtonTapped)
                        }) {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Plotfolio")
                .navigationBarItems(
                    trailing: HStack(spacing: 20) {
                        EditButton()
                    }
                )
                .navigationDestination(for: HomeScene.self) { scene in
                    switch scene {
                    case .editPlot:
                        IfLetStore(self.store.scope(state: \.editPlot, action: { .editPlot($0) })) {
                            EditPlotView(store: $0)
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: .init(), reducer: HomeStore()._printChanges()))
    }
}

