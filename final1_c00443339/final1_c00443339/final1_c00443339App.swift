//
//  final1_c00443339App.swift
//  final1_c00443339
//
//  Created by Tony Huynh on 11/23/21.
//

import SwiftUI

@main
struct final1_c00443339App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
