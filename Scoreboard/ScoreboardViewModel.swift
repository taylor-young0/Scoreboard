//
//  ScoreboardViewModel.swift
//  Scoreboard
//
//  Created by Taylor Young on 2023-06-03.
//

import Foundation
import SwiftUI
import Combine

enum Score {
    case firstScore, secondScore

    var colorKey: String {
        switch self {
        case .firstScore:
            return "firstColor"
        case .secondScore:
            return "secondColor"
        }
    }
}

final class ScoreboardViewModel: ObservableObject {
    @Published var firstScore: Int = 0
    @Published var secondScore: Int = 0
    @Published var firstColor: Color
    @Published var secondColor: Color
    @Published var showingSettings: Bool = false

    var userDefaults: UserDefaults

    private var cancellables: [AnyCancellable] = []

    init(userDefaults: UserDefaults = .standard) {
        let firstColor: Color? = userDefaults.color(forKey: Score.firstScore.colorKey)
        let secondColor: Color? = userDefaults.color(forKey: Score.secondScore.colorKey)

        self.firstColor = firstColor == nil ? .cyan : firstColor!
        self.secondColor = secondColor == nil ? .white : secondColor!
        self.userDefaults = userDefaults

        $firstColor
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] color in
                self?.saveColor(color, for: .firstScore)
            }
            .store(in: &cancellables)

        $secondColor
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] color in
                self?.saveColor(color, for: .secondScore)
            }
            .store(in: &cancellables)
    }

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

    func saveColor(_ color: Color, for score: Score) {
        userDefaults.set(color, forKey: score.colorKey)
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
