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
        XCTAssertEqual(sut.timer.isValid, false)
    }
    
    func testStartTimer_WhenNotRunning_StartsTimerAndChangeToRunning(){
        sut.configTime = 5
        sut.countDown = 1
        sut.startTimer { (_,hasEnded) in
            if hasEnded{
                XCTAssertEqual(self.sut.state, .pause)
                XCTAssertEqual(self.sut.convertedTimeValue, 1)
            }
        }
        XCTAssertEqual(sut.timer.isValid, true)
    }

    func testUpdateTrackedValues_WhenStatusProvided_IncrementStatisticsValues(){
        sut.focusTime = 0
        sut.restTime = 0
        sut.runningState = .focus
        sut.updateTrackedValues()
        sut.runningState = .pause
        sut.updateTrackedValues()
        XCTAssertEqual(sut.focusTime, 1)
        XCTAssertEqual(sut.restTime, 1)
    }

    func testChangeCicle_WhenStatusProvided_ChangeToNextStatus(){
        sut.runningState = .focus
        XCTAssertEqual(sut.changeCicle, .pause)
        sut.runningState = .pause
        XCTAssertEqual(sut.changeCicle, .focus)
    }

    func testConvertedTime_WhenTimeSet_ConvertToSecondsOrPauseTime(){
        sut.configTime = 5
        sut.state = .focus
        XCTAssertEqual(sut.convertedTimeValue, 300)
        sut.state = .pause
        XCTAssertEqual(sut.convertedTimeValue, 60)
    }

}
