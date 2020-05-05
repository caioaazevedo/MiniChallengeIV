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
        super.tearDown()
        timer = nil
        sut = nil
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
    
    func testReturnFromBackground_WhenTimerStatusIsFocus_DoNotChangeCicle() {
        timer.runningState = .focus
        sut.enterBackgroundInstant = Date()
        timer.lostFocusTime = 2 * 60 // 2 min
        timer.focusTime = 10 * 60 // 10 min
        timer.configTime = 25 // 25 min
        timer.countDown = 5 * 60 // 5 min remain
        
        sut.returnFromBackground()
        
        XCTAssertTrue(timer.countDown > 0)
        
    }
    
    func testReturnFromBackground_WhenTimerStatusIsFocus_ChangeCicle() {
        timer.runningState = .focus
        let minComp = DateComponents(minute: -11)
        let date = Calendar.current.date(byAdding: minComp, to: Date())
        
        sut.enterBackgroundInstant = date
        timer.lostFocusTime = 5 * 60 // 5 min
        timer.focusTime = 10 * 60 // 10 min
        timer.configTime = 25 // 25 min
        timer.countDown = 5 * 60 // 5 min remain
        
        sut.returnFromBackground()
        
        XCTAssertTrue(timer.countDown == 0)
        
    }
    
    func testReturnFromBackground_WhenTimerStatusIsPause_DoNotChangeCicle() {
        timer.runningState = .pause
        sut.enterBackgroundInstant = Date()
        timer.restTime = 2 * 60 // 2 min
        timer.configTime = 5 // 5 min
        timer.countDown = 3 * 60 // 5 min remain
        
        sut.returnFromBackground()
        
        XCTAssertTrue(timer.countDown > 0)
        
    }
    
    func testReturnFromBackground_WhenTimerStatusIsPause_ChangeCicle() {
        timer.runningState = .pause
        let minComp = DateComponents(minute: -5)
        let date = Calendar.current.date(byAdding: minComp, to: Date())

        sut.enterBackgroundInstant = date
        timer.restTime = 2 * 60 // 2 min
        timer.configTime = 5 // 5 min
        timer.countDown = 3 * 60 // 5 min remain

        sut.returnFromBackground()

        XCTAssertTrue(timer.countDown == 0)
        
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
    
    func testUpdateTimerAtributesWhenFocus_DecreaseCountdown(){
        /// When Time Isnt Over
        
        // Timer Simulation
        timer.runningState = .focus
        let lostFocusTime = 10 * 60 // 10 min
        timer.lostFocusTime = 2 * 60 // 2 min
        timer.focusTime = 10 * 60 // 10 min
        timer.configTime = 25 // 25 min
        timer.countDown = 5 * 60 // 5 min remain
        
        // Comparison constants
        let lostFocus = timer.lostFocusTime
        let timeRemain = timer.countDown
        
        let returnValue = sut.updateTimerAtributesWhenFocus(lostFocusTime: lostFocusTime)
        
        XCTAssertTrue(timer.lostFocusTime >= lostFocus)
        XCTAssertTrue(timer.countDown <= timeRemain)
        XCTAssertFalse(returnValue)
    }
    
    func testUpdateTimerAtributesWhenFocus_LostFocusGetsTimeLeftToRestartTimer(){
        /// When Time Is Over

        // Timer Simulation
        timer.runningState = .focus
        let lostFocusTime = 10 * 60 // 10 min
        timer.lostFocusTime = 6 * 60 // 6 min
        timer.focusTime = 10 * 60 // 10 min
        timer.configTime = 25 // 25 min

        let returnValue = sut.updateTimerAtributesWhenFocus(lostFocusTime: lostFocusTime)

        let totalTimeTrack = timer.lostFocusTime + timer.focusTime

        XCTAssertTrue(totalTimeTrack == timer.configTime * 60)
        XCTAssertTrue(returnValue)
    }
    
    func testUpdateTimerAtributesWhenPause_DecreaseCountdown(){
        /// When Time Isnt Over
        
        // Timer Simulation
        timer.runningState = .focus
        let restInBackgrund = 4 * 60 // 4 min
        timer.restTime = 0
        timer.configTime = 5 // 5 min
        timer.countDown = 5 * 60 // 5 min remain
        
        // Comparison constants
        let restTime = timer.restTime
        let timeRemain = timer.countDown
        
        let returnValue = sut.updateTimerAtributesWhenPause(restInBackgrund: restInBackgrund)
        
        XCTAssertTrue(timer.restTime >= restTime)
        XCTAssertTrue(timer.countDown <= timeRemain)
        XCTAssertFalse(returnValue)
    }
    
    func testUpdateTimerAtributesWhenPause_RestTimeGetsTimeLeftToRestartTimer(){
        /// When Time Is Over
        
        // Timer Simulation
        timer.runningState = .pause
        let restInBackgrund = 10 * 60 // 10 min
        timer.restTime = 5 * 60 // 5 min
        timer.configTime = 5 // 5 min
        timer.countDown = 5 * 60 // 5 min remain

        let returnValue = sut.updateTimerAtributesWhenPause(restInBackgrund: restInBackgrund)
        
        XCTAssertTrue(timer.restTime == timer.configTime * 60)
        XCTAssertTrue(returnValue)
    }
    
    func testChangeCicleTimer_changeStatusToFocus(){
        timer.runningState = .pause
        
        sut.changeCicleTimer()
        
        XCTAssertTrue(timer.state == .focus)
        XCTAssertTrue(timer.countDown == 0)
    }
    
    func testChangeCicleTimer_changeStatusToPause(){
        timer.runningState = .focus
        print("=-=-=-=>>> \(timer.state)")
        
        sut.changeCicleTimer()
        print("=-=-=-=>>> \(timer.state)")
        
        XCTAssertTrue(timer.state == .pause)
        XCTAssertTrue(timer.countDown == 0)
    }
}
