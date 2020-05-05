//
//  TimeTrackerBOTests.swift
//  MiniChallengeIVTests
//
//  Created by Fábio Maciel de Sousa on 05/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import XCTest
@testable import MiniChallengeIV


class TimeTrackerBOTests: XCTestCase {

    let sut = TimeTrackerBO()
    
    func testStringToSecond_WhenValidTextProvided_ConvertToSeconds(){
        XCTAssertEqual(sut.stringToSeconds(with: "15:00"), 900)
        XCTAssertEqual(sut.stringToSeconds(with: "-5:00"), 0)
        XCTAssertEqual(sut.stringToSeconds(with: "err"), 0)
    }

    func testSecondsToString_WhenValidValueProvided_ConvertToText(){
        XCTAssertEqual(sut.secondsToString(with: 60), "01:00")
        XCTAssertEqual(sut.secondsToString(with: -5), "")
    }

    func testStopTimer_WhenRunning_StopTimerAndChangeStatusToFocus(){
        sut.startTimer { (_, _) in}
        sut.stopTimer {}
        XCTAssertEqual(sut.state, .focus)
        XCTAssertFalse(sut.timer.isValid)
    }
    
    func testStartTimer_WhenNotRunning_StartsTimerAndChangeToRunning(){
        sut.stopTimer {}
        sut.configTime = 0
        sut.timeInterval = 0
        sut.startTimer { (time, hasEnded) in
            XCTAssertTrue(hasEnded)
            XCTAssertEqual(time, "00:00")
        }
        XCTAssertTrue(sut.timer.isValid)
        XCTAssertEqual(sut.countDown, 0)
    }

    func testUpdateTrackedValues_WhenStatusProvided_IncrementStatisticsValues(){
        sut.focusTime = 0
        sut.restTime = 0
        sut.state = .focus
        sut.updateTrackedValues()
        sut.state = .pause
        sut.updateTrackedValues()
        XCTAssertEqual(sut.focusTime, 1)
        XCTAssertEqual(sut.restTime, 1)
    }

    func testChangeCicle_WhenStatusProvided_ChangeToNextStatus(){
        sut.state = .focus
        XCTAssertEqual(sut.changeCicle, .pause)
        sut.state = .pause
        XCTAssertEqual(sut.changeCicle, .focus)
    }

    func testConvertedTime_WhenTimeSet_ConvertToSecondsOrPauseTime(){
        sut.configTime = 5
        sut.state = .focus
        XCTAssertEqual(sut.convertedTimeValue, 300)
        sut.state = .pause
        XCTAssertEqual(sut.convertedTimeValue, 60)
    }

    func testCountDown_WhenFinished_ChangeBooleanValue(){
        sut.hasEnded = false
        sut.countDown = 0
        XCTAssertTrue(sut.hasEnded)
    }
}
