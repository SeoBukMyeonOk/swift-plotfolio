//
//  SettingView.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/23.
//

import SwiftUI

import ComposableArchitecture

struct SettingView: View {
    public let store: StoreOf<SettingStore>
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: .zero) {
                List {
                    Label("info", systemImage: "info.circle.fill")
                        .foregroundColor(Color(.label))
                }
            }
            .navigationTitle("Setting")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(store: .init(initialState: .init(), reducer: SettingStore()._printChanges()))
    }
}
