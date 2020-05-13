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
        XCTAssertEqual(sut.stringToSeconds(from: "00:15:00"), 900)
        XCTAssertEqual(sut.stringToSeconds(from: "01:00:00"), 3600)
        XCTAssertEqual(sut.stringToSeconds(from: "00:-5:00"), 0)
        XCTAssertEqual(sut.stringToSeconds(from: "15:00"), 0)
        XCTAssertEqual(sut.stringToSeconds(from: "err"), 0)
        XCTAssertEqual(sut.stringToSeconds(from: "1050"), 0)
        XCTAssertEqual(sut.stringToSeconds(from: "err:00"), 0)
        XCTAssertEqual(sut.stringToSeconds(from: ":"), 0)
    }

    func testSecondsToString_WhenValidValueProvided_ConvertToText(){
        XCTAssertEqual(sut.secondsToString(with: 60), "00:01:00")
        XCTAssertEqual(sut.secondsToString(with: 3600), "01:00:00")
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
        XCTAssertEqual(sut.focusTime, 1)
        sut.state = .pause
        sut.updateTrackedValues()
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
    
    func testUpdateStatistics_WhenValuesProvided_AddsAndUpdatesToDataBase(){
        sut.focusTime = 0
        sut.restTime = 0
        sut.qtdLostFocus = 0
        sut.lostFocusTime = 0
        sut.updateStatistics()
        XCTAssertEqual(sut.focusTime, 0)
        XCTAssertEqual(sut.restTime, 0)
        XCTAssertEqual(sut.lostFocusTime, 0)
        XCTAssertEqual(sut.qtdLostFocus, 0)
    }
    //might be removed
    func testGetDate_WhenCalled_ReturnCurrentDate(){
        let timerComponents = sut.getDate()
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        if let timerYear = timerComponents.year,
            let timerMonth = timerComponents.month {
            XCTAssertEqual(timerYear, components.year)
            XCTAssertEqual(timerMonth, components.month)
        }
        XCTAssertNotNil(timerComponents.year)
        XCTAssertNotNil(timerComponents.month)
    }
    
    func testUpdateProject_WhenIdProvided_UpdatesDataBase(){
        let statistic = Statistic(id: UUID(), focusTime: 0, lostFocusTime: 0, restTime: 0, qtdLostFocus: 0, year: 0, month: 0)
        ///Its supossed to be false because the project Id hasnt been passed
        XCTAssertFalse(sut.updateProject(statistic: statistic))
    }
    
    func testAddStatistics_WhenStatisticProvided_AddStatisticValues(){
        var statisticA = Statistic(id: UUID(), focusTime: 1, lostFocusTime: 1, restTime: 1, qtdLostFocus: 1, year: 1, month: 1)
        let statisticB = Statistic(id: UUID(), focusTime: 1, lostFocusTime: 1, restTime: 1, qtdLostFocus: 1, year: 1, month: 1)
        statisticA += statisticB
        XCTAssertEqual(statisticA.focusTime, 2)
        XCTAssertEqual(statisticA.restTime, 2)
        XCTAssertEqual(statisticA.lostFocusTime, 2)
        XCTAssertEqual(statisticA.qtdLostFocus, 2)
    }
    
    func testAddProjectTime_WhenStatisticProvided_AddStatisticValues(){
        let statistic = Statistic(id: UUID(), focusTime: 1, lostFocusTime: 1, restTime: 1, qtdLostFocus: 1, year: 1, month: 1)
        var project = Project(id: UUID(), name: "Academy", color: .blue, time: 1)
        project += statistic
        XCTAssertEqual(project.time, 4)
    }
}
