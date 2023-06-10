//
//  ScoreboardViewModel.swift
//  Scoreboard
//
//  Created by Taylor Young on 2023-06-03.
//

import Foundation
import SwiftUI

enum Score {
    case firstScore, secondScore
}

final class ScoreboardViewModel: ObservableObject {
    @Published var firstScore: Int = 0
    @Published var secondScore: Int = 0
    @Published var firstColor: Color = .cyan
    @Published var secondColor: Color = .white
    @Published var showingSettings: Bool = false

    var minimumSwipeDistance: CGFloat {
        #if os(iOS)
            return 100
        #elseif os(watchOS)
            return 50
        #endif
    }

    func handleSwipe(with translation: CGSize, for score: Score) {
        if translation.height < 0 {
            score == .firstScore ? incrementFirstScore() : incrementSecondScore()
        } else {
            score == .firstScore ? decrementFirstScore() : decrementSecondScore()
        }
    }

    func resetScores() {
        firstScore = 0
        secondScore = 0
    }

    private func incrementFirstScore() {
        firstScore += 1
    }

    private func decrementFirstScore() {
        guard firstScore > 0 else {
            return
        }

        firstScore -= 1
    }

    private func incrementSecondScore() {
        secondScore += 1
    }

    private func decrementSecondScore() {
        guard secondScore > 0 else {
            return
        }

        secondScore -= 1
    }
}
