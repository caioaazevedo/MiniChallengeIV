//
//  DataChartBO.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 08/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
import Charts

class DataChartBO {
    var timeProjects: [Int]
    var totalTime: Int
    var projects: [Project]
    var projectColors = [NSUIColor]()
    
    init() {
        timeProjects = []
        totalTime = 0
        projectColors = []
        projects = []
    }
    
    /// Description:  Load the projects to insert data into the chart
    /// - Returns: Data to insert into the Chart View
    func loadChartData(completion: @escaping (PieChartData) ->  ()){
        /// Get Projects from database
        ProjectBO().retrieve { (projects) in
            guard let projects = projects else { return }
            
            self.projects = projects
            
            getTimeStatistics(projects: self.projects)
            
            let projectsPercentage = calculateProjectsPercentage()
            let entries = createDataEntries(projectsPercentage: projectsPercentage)
            
            let data = insertChartData(entries: entries)
            
            completion(data)
        }
    }
    
    /// Description: Get time statistics like total time and time for each project
    /// - Parameter projects: The projects to get the time statistics
    func getTimeStatistics(projects: [Project]){
        for proj in projects {
            let time = proj.time
            self.projectColors.append(proj.color as NSUIColor)
            self.timeProjects.append(time)
            self.totalTime += time
        }
    }
    
    /// Description: Calculates the percentage of each project in relation to its time
    /// - Returns: Returns an array of project percentage
    func calculateProjectsPercentage() -> [Double] {
        var projectsPercentage = [Double]()
        
        for time in timeProjects {
            let timePercentage = Double(time * 100) / Double(self.totalTime)
            projectsPercentage.append(timePercentage)
        }
        
        return projectsPercentage
    }
    
    /// Description: Create data entries to insert into the Chart
    /// - Parameter projectsPercentage: Get each projects percentage
    /// - Returns:Returns a array of the created Data Entry
    func createDataEntries(projectsPercentage: [Double]) -> [PieChartDataEntry]{
        var entries = [PieChartDataEntry]()
        for projPercentage in projectsPercentage{
            let entry = PieChartDataEntry(value: projPercentage)
            entry.label = "%"
            entries.append(entry)
        }
        
        return entries
    }
    
    /// Description: Insert the data into the Chart with the color of each project
    /// - Parameter entries: Get the eentries with the project time percentage
    func insertChartData(entries: [PieChartDataEntry]) -> PieChartData{
        let dataSet  = PieChartDataSet(entries: entries)
        dataSet.colors = self.projectColors
        dataSet.label = ""
        
        let data = PieChartData(dataSet: dataSet)
        
        return data
    }
}
