//
//  EditPlotView.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import SwiftUI

import ComposableArchitecture

struct EditPlotView: View {
    public let store: StoreOf<EditPlotStore>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("메모")
            }
        }
    }
}

struct EditPlotView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlotView(store: .init(initialState: .init(), reducer: EditPlotStore()._printChanges()))
    }
}

