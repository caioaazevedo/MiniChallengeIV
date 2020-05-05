//
//  TimeTrackerBOTest.swift
//  MiniChallengeIVTests
//
//  Created by Fábio Maciel de Sousa on 04/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import XCTest
@testable import MiniChallengeIV

class TimeTrackerBOTests: XCTestCase{
    
    let t = TimeTrackerBO()
    
    func testStringToSecond(){
        XCTAssertEqual(t.stringToSeconds(with: "15:00"), 900)
        XCTAssertEqual(t.stringToSeconds(with: "100:00"), 0)
        XCTAssertEqual(t.stringToSeconds(with: "-5:00"), 0)
        XCTAssertEqual(t.stringToSeconds(with: "err"), 0)
        XCTAssertEqual(t.stringToSeconds(with: "1:00"), 0)
        XCTAssertEqual(t.stringToSeconds(with: "20:00"), 1200)
    }
    
    func testSecondsToString(){
        XCTAssertEqual(t.secondsToString(with: 60), "01:00")
        XCTAssertEqual(t.secondsToString(with: 300), "05:00")
        XCTAssertEqual(t.secondsToString(with: -5), "")
        XCTAssertEqual(t.secondsToString(with: 6060), "")
    }
    
    func testStopTimer(){
        let stopTimer = t.stopTimer {}
        XCTAssertEqual(t.state, .focus)
        XCTAssertNil(stopTimer)
    }
    
    func testStartTimer(){
        t.configTime = 5
        let startTimer = t.startTimer { (_,hasEnded) in
            if hasEnded{
                XCTAssertEqual(t.state, .pause)
                XCTAssertEqual(t.convertedTimeValue, 1)
            }
        }
        XCTAssertEqual(t.state, .running)
    }
    
    func testUpdateValues(){
        t.focusTime = 0
        t.restTime = 0
        t.state = .focus
        t.updateStatistics()
        t.state = .pause
        t.updateStatistics()
        XCTAssertEqual(t.focusTime, 1)
        XCTAssertEqual(t.restTime, 1)
    }
    
    func testChangeCicle(){
        t.state = .focus
        XCTAssertEqual(t.changeCicle, .pause)
        XCTAssertEqual(t.changeCicle, .focus)
    }
    
    func testConvertedTime(){
        t.configTime = 5
        t.state = .focus
        XCTAssertEqual(t.convertedTimeValue, 300)
        t.state = .pause
        XCTAssertEqual(t.convertedTimeValue, 60)
    }
}
