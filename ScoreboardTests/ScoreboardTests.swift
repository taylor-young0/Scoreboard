//
//  ScoreboardTests.swift
//  ScoreboardTests
//
//  Created by Taylor Young on 2022-06-30.
//

import XCTest
@testable import Scoreboard

class ScoreboardTests: XCTestCase {

    private var sut: ScoreboardViewModel!
    private let swipeUp: CGSize = CGSize(width: 0, height: -100)
    private let swipeDown: CGSize = CGSize(width: 0, height: 100)

    override func setUpWithError() throws {
        sut = ScoreboardViewModel()
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

}
