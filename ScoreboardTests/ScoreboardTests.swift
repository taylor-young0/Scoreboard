//
//  ScoreboardTests.swift
//  ScoreboardTests
//
//  Created by Taylor Young on 2022-06-30.
//

import XCTest
import SwiftUI
import Combine
@testable import Scoreboard

class ScoreboardTests: XCTestCase {

    private var sut: ScoreboardViewModel!
    private var userDefaults: UserDefaults!
    private let swipeUp: CGSize = CGSize(width: 0, height: -100)
    private let swipeDown: CGSize = CGSize(width: 0, height: 100)
    private var cancellables: [AnyCancellable] = []

    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        sut = ScoreboardViewModel(userDefaults: userDefaults)
        cancellables = []
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testScoresStartAtZero() {
        XCTAssertEqual(sut.firstScore, 0)
        XCTAssertEqual(sut.secondScore, 0)
    }

    func testSwipeUpIncreasesFirstScore() {
        XCTAssertEqual(sut.firstScore, 0)
        XCTAssertEqual(sut.secondScore, 0)
        sut.handleSwipe(with: swipeUp, for: .firstScore)
        XCTAssertEqual(sut.firstScore, 1)
        XCTAssertEqual(sut.secondScore, 0)
    }

    func testSwipeDownDecreasesFirstScore() {
        sut.firstScore = 5
        XCTAssertEqual(sut.secondScore, 0)
        sut.handleSwipe(with: swipeDown, for: .firstScore)
        XCTAssertEqual(sut.firstScore, 4)
        XCTAssertEqual(sut.secondScore, 0)
    }

    func testSwipeUpIncreasesSecondScore() {
        XCTAssertEqual(sut.firstScore, 0)
        XCTAssertEqual(sut.secondScore, 0)
        sut.handleSwipe(with: swipeUp, for: .secondScore)
        XCTAssertEqual(sut.firstScore, 0)
        XCTAssertEqual(sut.secondScore, 1)
    }

    func testSwipeDownDecreasesSecondScore() {
        sut.secondScore = 5
        XCTAssertEqual(sut.firstScore, 0)
        sut.handleSwipe(with: swipeDown, for: .secondScore)
        XCTAssertEqual(sut.firstScore, 0)
        XCTAssertEqual(sut.secondScore, 4)
    }

    func testScoreCannotBeNegative() {
        sut.handleSwipe(with: swipeDown, for: .firstScore)
        XCTAssertEqual(sut.firstScore, 0)

        sut.handleSwipe(with: swipeDown, for: .secondScore)
        XCTAssertEqual(sut.secondScore, 0)
    }

    func testSettingsSheetStartsHidden() {
        XCTAssertFalse(sut.showingSettings)
    }

    func testScoresResetToZero() {
        sut.firstScore = 10
        sut.secondScore = 9
        sut.resetScores()

        XCTAssertEqual(sut.firstScore, 0)
        XCTAssertEqual(sut.secondScore, 0)
    }

    func testDefaultFirstScoreColor() {
        XCTAssertEqual(sut.firstColor, Color.cyan)
    }

    func testDefaultSecondScoreColor() {
        XCTAssertEqual(sut.secondColor, Color.white)
    }

    func testColorSaves() {
        sut.saveColor(Color.gray, for: .firstScore)
        sut.saveColor(Color.black, for: .secondScore)

        XCTAssertEqual(
            try? NSKeyedArchiver.archivedData(withRootObject: UIColor(Color.gray), requiringSecureCoding: false),
            userDefaults.data(forKey: Score.firstScore.colorKey)
        )

        XCTAssertEqual(
            try? NSKeyedArchiver.archivedData(withRootObject: UIColor(Color.black), requiringSecureCoding: false),
            userDefaults.data(forKey: Score.secondScore.colorKey)
        )
    }

    func testSavedColorLoads() {
        sut.saveColor(Color.orange, for: .firstScore)
        sut.saveColor(Color.mint, for: .secondScore)

        sut = ScoreboardViewModel(userDefaults: userDefaults)

        XCTAssertEqual(
            try? NSKeyedArchiver.archivedData(withRootObject: UIColor(sut.firstColor), requiringSecureCoding: false),
            try? NSKeyedArchiver.archivedData(withRootObject: UIColor(Color.orange), requiringSecureCoding: false)
        )

        XCTAssertEqual(
            try? NSKeyedArchiver.archivedData(withRootObject: UIColor(sut.secondColor), requiringSecureCoding: false),
            try? NSKeyedArchiver.archivedData(withRootObject: UIColor(Color.mint), requiringSecureCoding: false)
        )
    }

    func testEditingScoresThroughContextMenuFocusesAndClears() {
        sut.editScore(.firstScore)
        XCTAssertTrue(sut.showingSettings)
        XCTAssertEqual(sut.isEditingScore, .firstScore)

        sut.showingSettings = false

        sut.editScore(.secondScore)
        XCTAssertTrue(sut.showingSettings)
        XCTAssertEqual(sut.isEditingScore, .secondScore)

        sut.showingSettings = false
        XCTAssertNil(sut.isEditingScore)
    }

    func testScoreSizeStartsNormal() {
        XCTAssertEqual(sut.firstScoreSize, .normal)
        XCTAssertEqual(sut.secondScoreSize, .normal)
    }

    func testIncreasingScoreIncreasesFontSize() {
        // First score should use expanded font size when score is increased
        sut.handleSwipe(with: swipeUp, for: .firstScore)
        waitForScoreFontSizeWith(expectedSize: .expanded, on: .firstScore)

        // First score should revert back to normal font size
        waitForScoreFontSizeWith(expectedSize: .normal, on: .firstScore)

        // Second score should use expanded font size when score is increased
        sut.handleSwipe(with: swipeUp, for: .secondScore)
        waitForScoreFontSizeWith(expectedSize: .expanded, on: .secondScore)

        // Second score should revert back to normal font size
        waitForScoreFontSizeWith(expectedSize: .normal, on: .secondScore)
    }

    func testDecreasingScoreDecreasesFontSize() {
        // First score should use shrunken font size when score is decreased
        sut.handleSwipe(with: swipeUp, for: .firstScore)
        sut.handleSwipe(with: swipeDown, for: .firstScore)
        waitForScoreFontSizeWith(expectedSize: .shrunken, on: .firstScore, droppingFirst: 2)

        // First score should revert back to normal font size
        waitForScoreFontSizeWith(expectedSize: .normal, on: .firstScore)

        // Second score should use shrunken font size when score is decreased
        sut.handleSwipe(with: swipeUp, for: .secondScore)
        sut.handleSwipe(with: swipeDown, for: .secondScore)
        waitForScoreFontSizeWith(expectedSize: .shrunken, on: .secondScore, droppingFirst: 2)

        // Second score should revert back to normal font size
        waitForScoreFontSizeWith(expectedSize: .normal, on: .secondScore)
    }

    func waitForScoreFontSizeWith(expectedSize: ScoreSize, on score: Score, droppingFirst count: Int = 1) {
        let scoreSizeExpectation: XCTestExpectation = XCTestExpectation()
        let scoreSizePublisher = score == .firstScore ? sut.$firstScoreSize : sut.$secondScoreSize

        scoreSizePublisher
            .dropFirst(count)
            .sink { size in
                XCTAssertEqual(size, expectedSize)
                scoreSizeExpectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [scoreSizeExpectation], timeout: 0.5)

        cancellables = []
    }
}
