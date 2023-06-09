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
    
    @Environment(\.isSearching) private var isSearching
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(\.$path)) {
                VStack(spacing: .zero) {
                    List {
                        ForEachStore(self.store.scope(state: \.filteredPlotListCells, action: HomeStore.Action.plotListCell(id:action:))) { store in
                            PlotListCellView(store: store)
                        }
                        .onDelete { viewStore.send(.delete($0)) }
                    }
                    .refreshable {
                        viewStore.send(.refresh)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action:{
                            viewStore.send(.addButtonTapped)
                        }) {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                        }
                        .padding(.horizontal)
                    }
                }
                .onAppear {
                    viewStore.send(.refresh)
                }
                .navigationTitle("Plotfolio")
                .navigationBarItems(
                    trailing: HStack(spacing: 10) {
                        EditButton()
                        
                        Button(action:{
                            viewStore.send(.settingButtonTapped)
                        }) {
                            Image(systemName: "gearshape")
                                .imageScale(.medium)
                        }
                    }
                )
                .navigationDestination(for: HomeScene.self) { scene in
                    switch scene {
                    case .editPlot:
                        IfLetStore(self.store.scope(state: \.editPlot, action: { .editPlot($0) })) {
                            EditPlotView(store: $0)
                        }
                        
                    case .setting:
                        IfLetStore(self.store.scope(state: \.setting, action: { .setting($0) })) {
                            SettingView(store: $0)
                        }
                        
                    default:
                        EmptyView()
                    }
                }
                .searchable(
                    text: viewStore.binding(
                        get: { $0.searchQuery },
                        send: { .search($0) }
                    ),
                    placement: .toolbar,
                    prompt: "Search"
                )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .init(initialState: .init(), reducer: HomeStore()._printChanges()))
    }
}

