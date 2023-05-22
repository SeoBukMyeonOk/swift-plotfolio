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
            VStack {
                HStack {
                    Text(viewStore.plot.title ?? "")
                        .font(.body)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                HStack {
                    Text(viewStore.plot.content ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewStore.send(.tapped)
            }
        }
    }
}
