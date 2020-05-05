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
    
    let t = TimeTracker()
    
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
        let startTimer = t.startTimer { (_,_) in}
        
    }
    
}
