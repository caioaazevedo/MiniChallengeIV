//
//  AnimatedRingViewTests.swift
//  MiniChallengeIVTests
//
//  Created by Fábio Maciel de Sousa on 12/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import XCTest
@testable import MiniChallengeIV

class AnimatedRingViewTests: XCTestCase {
    
    let sut = AnimatedRingView()
    
    func testLayoutSubviews_WhenViewLoaded_DrawLayers(){
        let radius = (min(sut.frame.size.width, sut.frame.size.height) - sut.ringStrokeWidth - 2)/2
        let pos = CGPoint(x: sut.frame.size.width/2, y: sut.frame.size.height/2)
        let circlePath = UIBezierPath(arcCenter: pos, radius: radius, startAngle: sut.startAngle, endAngle: sut.startAngle + 2 * CGFloat.pi, clockwise: true)

        sut.layoutSubviews()
        XCTAssertEqual(sut.ringlayer.superlayer, sut.layer)
        XCTAssertEqual(sut.circleLayer.superlayer, sut.layer)
        XCTAssertEqual(sut.pinlayer.superlayer, sut.layer)
        XCTAssertEqual(sut.circleLayer.path, circlePath.cgPath)
        XCTAssertEqual(sut.ringlayer.path, circlePath.cgPath)

    }
    
    func testAnimateRing_WhenCalled_StartsProgressionAnimation(){
        sut.animateRing(From: 0, FromAngle: 0, To: 0, Duration: 0)
        XCTAssertNotNil(sut.ringlayer.animation(forKey: "animateRing"))
        XCTAssertNotNil(sut.pinlayer.animation(forKey: "animatePin"))
        XCTAssertTrue(sut.isRunning)

    }
    
    func testRemoveAnimation_WhenCalled_ResetsAnimationToStartingPoint(){
        sut.animateRing(From: 0, FromAngle: 0, To: 0, Duration: 0)
        sut.removeAnimation()
        XCTAssertNil(sut.ringlayer.animation(forKey: "animateRing"))
        XCTAssertNil(sut.pinlayer.animation(forKey: "animatePin"))
        XCTAssertFalse(sut.isRunning)
        XCTAssertEqual(sut.proportion, 0)
    }
    
    func testCalculateStartingPoint_WhenValuesProvided_ReturnNewPosition(){
        sut.totalTime = 1
        XCTAssertEqual(sut.calculateStartingPoint(With: 0.5, And: 1), 0.5)
        XCTAssertEqual(sut.calculateStartingPoint(With: -0.5, And: 1), 1)
    }

}
