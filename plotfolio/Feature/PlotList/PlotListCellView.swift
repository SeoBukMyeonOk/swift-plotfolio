//
//  PlotListCell.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import SwiftUI

import ComposableArchitecture

struct PlotListCellView: View {
    let store: StoreOf<PlotListCellStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Button(action: { viewStore.send(.checkBoxToggled) }) {
                    Image(systemName: viewStore.isComplete ? "checkmark.square" : "square")
                }
                .buttonStyle(.plain)
                
                TextField(
                    "Untitled Todo",
                    text: viewStore.binding(get: \.description, send: PlotListCellStore.Action.textFieldChanged)
                )
            }
            .foregroundColor(viewStore.isComplete ? .gray : nil)
        }
    }
}
