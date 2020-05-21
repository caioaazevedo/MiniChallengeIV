//
//  DataChartBOTests.swift
//  MiniChallengeIVTests
//
//  Created by Caio Azevedo on 08/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import XCTest
@testable import MiniChallengeIV
import Charts

class DataChartBOTests: XCTestCase {
    
    var sut: DataChartBO!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = DataChartBO()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testLoadChartData_ReturnChartDataWithProjectData() {
        
    }
    
    func testGetTimeStatstics_getTimeAndColorFromProjects(){
        let projHome = Project(id: UUID(), name: "Home", color: UIColor.init(hex: "#C1578C")!, time: 30)
        let projWork = Project(id: UUID(), name: "Work", color: UIColor.init(hex: "#AA42AE")!, time: 20)
        let projectsArray = [projHome, projWork]
        
        sut.getTimeStatistics(projects: projectsArray)
        
        XCTAssertNotEqual(sut.projectColors, [])
        XCTAssertNotEqual(sut.timeProjects, [])
        XCTAssertTrue(sut.totalTime > 0)
    }
    
    func testCalculateProjectsPercentage_ConvertToPercentage() {
        sut.timeProjects = [27, 23]
        sut.totalTime = 50
        
        let percentage = sut.calculateProjectsPercentage()
        
        XCTAssertTrue(percentage.count > 0)
        
        XCTAssertEqual(percentage[0], 54.0)
        XCTAssertEqual(percentage[1], 46.0)
    }
    
    func testCreateDataEntries_ConvertTheDataToDataEntries(){
        let projPercentage = [54.0, 46.0]
        
        let entries = sut.createDataEntries(projectsPercentage: projPercentage)
        
        XCTAssertTrue(entries.count > 0)
        XCTAssertEqual(entries[0].value, projPercentage[0])
    }
    
    func testInsertCharData_ConvertEntriesToChartData() {
        let firstColor = UIColor.init(hex: "#C1578C")! as NSUIColor
        let secondColor = UIColor.init(hex: "#AA42AE")! as NSUIColor
        sut.projectColors = [firstColor, secondColor]
        let entries = [PieChartDataEntry(value: 54.0), PieChartDataEntry(value: 54.0)]
        
        let data = sut.insertChartData(entries: entries)
        
        XCTAssertTrue(data.dataSetCount > 0)
        XCTAssertEqual(data.dataSets[0].colors, sut.projectColors)
    }
}
