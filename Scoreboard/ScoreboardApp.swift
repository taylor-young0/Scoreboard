//
//  ScoreboardApp.swift
//  Scoreboard
//
//  Created by Taylor Young on 2022-06-30.
//

import SwiftUI

@main
struct ScoreboardApp: App {
    var body: some Scene {
        WindowGroup {
            ScoreboardView()
                .environmentObject(ScoreboardViewModel())
        }
    }
}
