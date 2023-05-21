//
//  plotfolioApp.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/20.
//

import SwiftUI

@main
struct mainApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView(store: .init(initialState: .init(), reducer: RootStore()._printChanges()))
        }
    }
}
