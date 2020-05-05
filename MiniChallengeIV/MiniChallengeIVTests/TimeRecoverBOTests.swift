//
//  LostTimeFocusBOTests.swift
//  MiniChallengeIVTests
//
//  Created by Caio Azevedo on 04/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import XCTest
@testable import MiniChallengeIV

class TimeRecoverBOTests: XCTestCase {
    
    var timer: TimeTracker!
    var sut: TimeRecoverBO!
    var enterBackgroundInstant: Date!

    override func setUp(){
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        timer = TimeTracker()
        sut = TimeRecoverBO(timer: timer)
    }

    override func tearDown(){
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        timer = nil
        sut = nil
        super.tearDown()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEnterBackground_enterBackgroundInstantNotNil(){
        /// Timer Status - Focus
        timer.runningState = TimeTrackerState.focus
        
        sut.enterbackground()
        
        XCTAssertNotNil(sut.enterBackgroundInstant)
    }

    func testEnterBackground_sendNotification(){
        /// Timer Status - Pause
        timer.runningState = TimeTrackerState.pause
        
        sut.enterbackground()
        
        /// Ensure notification
    }

    ///when TimerState is Focus and return before Time Stops
    func testBackgroundTimeRecover_recoverDifferenceBetweenDates(){
        let backgroundInstant = Date()
        
        let returnValue = sut.backgroundTimeRecover(backgroundInstant: backgroundInstant)
        
        XCTAssertNotNil(sut.returnFromBackgroundInstant)
        
        XCTAssertTrue(returnValue >= 0)
    }

    
}
