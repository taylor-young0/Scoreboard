//
//  ScoreboardApp.swift
//  Scoreboard WatchKit Extension
//
//  Created by Taylor Young on 2022-06-30.
//

import SwiftUI

@main
struct ScoreboardApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
