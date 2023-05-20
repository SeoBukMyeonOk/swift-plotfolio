//
//  plotfolioApp.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/20.
//

import SwiftUI

@main
struct plotfolioApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
