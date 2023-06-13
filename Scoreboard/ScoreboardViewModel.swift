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

enum ScoreSize {
    case shrunken, normal, expanded
}

final class ScoreboardViewModel: ObservableObject {
    @Published var firstScore: Int = 0
    @Published var secondScore: Int = 0
    @Published var firstColor: Color
    @Published var secondColor: Color
    @Published var showingSettings: Bool = false
    @Published var firstScoreSize: ScoreSize = .normal
    @Published var secondScoreSize: ScoreSize = .normal

    var userDefaults: UserDefaults
    var isEditingScore: Score?

    private var cancellables: [AnyCancellable] = []

    init(userDefaults: UserDefaults = .standard) {
        let firstColor: Color? = userDefaults.color(forKey: Score.firstScore.colorKey)
        let secondColor: Color? = userDefaults.color(forKey: Score.secondScore.colorKey)

        self.firstColor = firstColor == nil ? .cyan : firstColor!
        self.secondColor = secondColor == nil ? .white : secondColor!
        self.userDefaults = userDefaults

        $firstColor
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] color in
                self?.saveColor(color, for: .firstScore)
            }
            .store(in: &cancellables)

        $secondColor
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] color in
                self?.saveColor(color, for: .secondScore)
            }
            .store(in: &cancellables)

        $showingSettings
            .dropFirst()
            .sink { [weak self] value in
                if value == false {
                    self?.isEditingScore = nil
                }
            }
            .store(in: &cancellables)

        $firstScore
            .dropFirst()
            .delay(for: 0.05, scheduler: RunLoop.main)
            .scan((older: 0, newer: 0)) { previousValues, nextValue in
                return (previousValues.newer, nextValue)
            }
            .sink { [weak self] recentScores in
                let scoreDifference: Int = recentScores.newer - recentScores.older
                self?.firstScoreSize = scoreDifference >= 0 ? .expanded : .shrunken
            }
            .store(in: &cancellables)

        $secondScore
            .dropFirst()
            .delay(for: 0.05, scheduler: RunLoop.main)
            .scan((older: 0, newer: 0)) { previousValues, nextValue in
                return (previousValues.newer, nextValue)
            }
            .sink { [weak self] recentScores in
                let scoreDifference: Int = recentScores.newer - recentScores.older
                self?.secondScoreSize = scoreDifference >= 0 ? .expanded : .shrunken
            }
            .store(in: &cancellables)

        $firstScoreSize
            .filter({
                $0 == .shrunken || $0 == .expanded
            })
            .delay(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.firstScoreSize = .normal
            }
            .store(in: &cancellables)

        $secondScoreSize
            .filter({
                $0 == .shrunken || $0 == .expanded
            })
            .delay(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.secondScoreSize = .normal
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

    func fontSize(for score: Score) -> CGFloat {
        #if os(iOS)
        let scoreSize: ScoreSize = score == .firstScore ? firstScoreSize : secondScoreSize
        switch scoreSize {
        case .shrunken:
            return 80
        case .normal:
            return 100
        case .expanded:
            return 120
        }
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

    func editScore(_ score: Score) {
        isEditingScore = score
        showingSettings = true
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
